//
//  URLNetworkClient.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 19-11-25.
//  Updated: Consolidated network client with optional interceptor support
//

import Foundation

/// Unified network client that supports both public and authenticated requests.
///
/// This client can operate in two modes:
///
/// **Without Interceptor (Public Endpoints)**
/// - Simple pass-through to URLSession
/// - No token injection or refresh
/// - Returns (Data, URLResponse)
/// - Ideal for login, register, and other public endpoints
///
/// **With Interceptor (Authenticated Endpoints)**
/// - Automatically injects authentication tokens via `adapt()`
/// - Detects 401 Unauthorized responses
/// - Triggers token refresh via `shouldRetry()`
/// - Retries the original request with the new token
/// - Returns only Data (response handling done by interceptor)
///
/// ## Usage Examples
///
/// ```swift
/// // For public endpoints (no authentication)
/// let publicClient = URLNetworkClient()
/// let (data, response) = try await publicClient.execute(request)
///
/// // For authenticated endpoints
/// let interceptor = AuthInterceptor(tokenManager: tokenManager)
/// let authClient = URLNetworkClient(interceptor: interceptor)
/// let data = try await authClient.executeWithInterceptor(request)
/// ```
///
final class URLNetworkClient: NetworkClientProtocol, InterceptableNetworkClientProtocol {
    private let session: URLSession
    private let interceptor: RequestInterceptor?
    
    /// Initializes the network client
    ///
    /// - Parameters:
    ///   - session: URLSession to use for requests. Defaults to `.shared`
    ///   - interceptor: Optional interceptor for authentication handling
    init(session: URLSession = .shared, interceptor: RequestInterceptor? = nil) {
        self.session = session
        self.interceptor = interceptor
    }
    
    // MARK: - NetworkClientProtocol (Public endpoints)
    
    /// Executes a request without interceptor support.
    /// Returns the full response for public endpoints that don't need authentication.
    ///
    /// - Parameter request: The URLRequest to execute
    /// - Returns: Tuple of (Data, URLResponse)
    /// - Throws: URLError or transport-level errors
    func execute(_ request: URLRequest) async throws -> (Data, URLResponse) {
        return try await session.data(for: request)
    }
    
    // MARK: - InterceptableNetworkClientProtocol (Authenticated endpoints)
    
    /// Executes a request with interceptor support for authenticated endpoints.
    ///
    /// The flow is:
    /// 1. Call `interceptor.adapt()` to inject authentication token
    /// 2. Execute the request
    /// 3. If response is 401, call `interceptor.shouldRetry()` to handle token refresh
    /// 4. Retry the original request if instructed
    ///
    /// - Parameter request: The URLRequest to execute
    /// - Returns: Response data only (interceptor handles response analysis)
    /// - Throws: Network errors, authentication errors, or interceptor errors
    func execute(_ request: URLRequest) async throws -> Data {
        guard let interceptor = interceptor else {
            // If no interceptor is configured, fall back to simple execution
            let (data, _) = try await execute(request)
            return data
        }
        
        // 1. Adapt: Inject authentication token
        var finalRequest = await interceptor.adapt(request)
        
        // 2. Execute the request
        do {
            let (data, response) = try await session.data(for: finalRequest)
            
            // 3. Check for 401 Unauthorized to trigger refresh flow
            if let httpResponse = response as? HTTPURLResponse,
               httpResponse.statusCode == 401 {
                
                // Ask interceptor what to do (refresh token and retry?)
                let action = await interceptor.shouldRetry(
                    finalRequest,
                    with: URLError(.userAuthenticationRequired),
                    response: httpResponse
                )
                
                switch action {
                case .retry:
                    // Recursively retry with original request
                    // When it re-enters, adapt() will pick up the NEW token
                    return try await execute(request)
                    
                case .doNotRetry:
                    // Return data as-is (caller should handle the 401)
                    return data
                    
                case .doNotRetryWithError(let error):
                    // Interceptor wants to throw a specific error (e.g., refresh failed)
                    throw error
                }
            }
            
            // 4. If not 401, return data normally
            return data
            
        } catch let error as URLError {
            // Network errors: propagate directly
            throw error
        } catch {
            // Other errors: propagate
            throw error
        }
    }
}

