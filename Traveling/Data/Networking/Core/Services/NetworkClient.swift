//
//  NetworkClient.swift
//  Traveling
//
//  Created by Daniel Retamal on 18-11-25.
//

import Foundation

/// Unified network client for public and authenticated endpoints.
///
/// If an interceptor is provided, it handles authentication and token refresh.
/// If not, it works as a simple client for public endpoints.
class NetworkClient: NetworkClientProtocol, InterceptableNetworkClientProtocol {
    private let session: URLSession
    private let interceptor: RequestInterceptor?

    init(session: URLSession = .shared, interceptor: RequestInterceptor? = nil) {
        self.session = session
        self.interceptor = interceptor
    }

    /// Executes a request and returns only Data (for authenticated endpoints)
    func execute(_ request: URLRequest) async throws -> Data {
        let (data, _) = try await executeWithResponse(request)
        return data
    }

    /// Executes a request and returns Data and URLResponse (for public endpoints)
    func execute(_ request: URLRequest) async throws -> (Data, URLResponse) {
        return try await executeWithResponse(request)
    }

    /// Shared internal logic
    private func executeWithResponse(_ request: URLRequest) async throws -> (Data, URLResponse) {
        var finalRequest = request
        if let interceptor = interceptor {
            finalRequest = await interceptor.adapt(request)
        }

        do {
            let (data, response) = try await session.data(for: finalRequest)

            if let httpResponse = response as? HTTPURLResponse,
               httpResponse.statusCode == 401,
               let interceptor = interceptor {
                let action = await interceptor.shouldRetry(
                    finalRequest,
                    with: URLError(.userAuthenticationRequired),
                    response: httpResponse
                )
                switch action {
                case .retry:
                    return try await executeWithResponse(request)
                case .doNotRetry:
                    return (data, response)
                case .doNotRetryWithError(let error):
                    throw error
                }
            }
            return (data, response)
        } catch let error as URLError {
            throw error
        } catch {
            throw error
        }
    }
}
