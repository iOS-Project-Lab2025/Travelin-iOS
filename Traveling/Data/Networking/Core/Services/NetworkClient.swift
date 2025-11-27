//
//  NetworkClient.swift
//  Traveling
//
//  Created by Daniel Retamal on 18-11-25.
//

import Foundation

class NetworkClient: NetworkClientProtocol {
    private let session: URLSession
    private let interceptor: RequestInterceptor? // Injected
    
    init(session: URLSession = .shared, interceptor: RequestInterceptor? = nil) {
        self.session = session
        self.interceptor = interceptor
    }
    
    func execute(_ request: URLRequest) async throws -> Data {
        // 1. Adapt (inject token)
        var finalRequest = request
        if let interceptor = interceptor {
            finalRequest = await interceptor.adapt(request)
        }
        
        // 2. Execute
        do {
            let (data, response) = try await session.data(for: finalRequest)
            
            // 3. Check if it's 401 to intercept
            if let httpResponse = response as? HTTPURLResponse, 
               httpResponse.statusCode == 401, 
               let interceptor = interceptor {
                
                // Ask the interceptor what to do
                let action = await interceptor.shouldRetry(
                    finalRequest, 
                    with: URLError(.userAuthenticationRequired), 
                    response: httpResponse
                )
                
                switch action {
                case .retry:
                    // RECURSION: Call execute again.
                    // When it enters, interceptor.adapt() will pick up the NEW token that was just saved.
                    return try await execute(request) // Note: use original 'request' without dirty headers
                    
                case .doNotRetry:
                    // Return data as is (the caller should handle the 401)
                    return data
                    
                case .doNotRetryWithError(let error):
                    // The interceptor decided to throw a different error (e.g., refresh failed)
                    throw error
                }
            }
            
            // 4. If it's not 401, return data normally
            return data
            
        } catch let error as URLError {
            // If it's a network error (timeout, no connection), propagate it directly
            throw error
        } catch {
            // Other errors (e.g., decoding), propagate them
            throw error
        }
    }
}
