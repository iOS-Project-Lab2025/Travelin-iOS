//
//  Services.swift
//  Traveling
//
//  Simplified service access - Direct singletons approach

import Foundation

/// Global services configuration
enum Services {
    
    // MARK: - Configuration
    private static var baseURL: URL = {
        #if DEBUG
        return URL(string: "http://localhost:3000")!
        #else
        return URL(string: "https://api.travelin.com")!
        #endif
    }()
    
    // MARK: - Core Dependencies
    
    static let tokenManager: TokenManaging = KeychainTokenManager()
    
    private static let endpointBuilder = EndPointBuilder(baseURL: baseURL)
    private static let payloadBuilder = PayloadBuilder()
    private static let requestBuilder = RequestBuilder(
        endPointBuilder: endpointBuilder,
        payloadBuilder: payloadBuilder
    )
    
    // MARK: - Network Clients
    
    /// Public client: For endpoints that don't require authentication (login, register, etc.)
    private static let publicClient = URLNetworkClient()
    
    /// Authenticated client: For endpoints that require authentication (user profile, bookings, etc.)
    /// Automatically handles token injection and refresh via AuthInterceptor
    private static let authenticatedClient: InterceptableNetworkClientProtocol = {
        let interceptor = AuthInterceptor(tokenManager: tokenManager)
        return URLNetworkClient(interceptor: interceptor)
    }()
    
    // MARK: - Services
    
    /// Authentication service: Uses public client (no auth required for login/register)
    static let auth = AuthService(
        client: publicClient,
        requestBuilder: requestBuilder
    )
    
    /// User service: Uses authenticated client (requires valid access token)
    static let user = UserService(
        client: authenticatedClient,
        requestBuilder: requestBuilder
    )
}
