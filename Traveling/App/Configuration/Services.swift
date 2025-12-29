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

    // MARK: - Unified Network Client

    private static let networkClient = NetworkClient()
    private static let authenticatedNetworkClient: InterceptableNetworkClientProtocol = {
        let interceptor = AuthInterceptor(tokenManager: tokenManager)
        return NetworkClient(interceptor: interceptor)
    }()

    // MARK: - Services

    static let auth = AuthService(
        client: networkClient,
        requestBuilder: requestBuilder
    )

    static let user = UserService(
        client: authenticatedNetworkClient,
        requestBuilder: requestBuilder
    )
}
