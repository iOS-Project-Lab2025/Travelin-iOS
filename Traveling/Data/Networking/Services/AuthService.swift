//
//  AuthService.swift
//  Traveling
//
//  Created by Daniel Retamal on 27-11-25.
//

import Foundation

/// Service responsible for authentication operations (login, refresh)
/// Uses URLNetworkClient since these endpoints don't require prior authentication
class AuthService {
    
    private let client: NetworkClientProtocol
    private let requestBuilder: RequestBuilderProtocol
    
    init(client: NetworkClientProtocol, requestBuilder: RequestBuilderProtocol) {
        self.client = client
        self.requestBuilder = requestBuilder
    }
    
    // MARK: - Login
    /// Performs user login with email and password
    /// - Parameters:
    ///   - email: User's email
    ///   - password: User's password
    /// - Returns: LoginResponse containing access and refresh tokens
    func login(email: String, password: String) async throws -> LoginResponse {
        let endpoint = UserEndpoint.login(email: email, password: password)
        
        // ✅ CRITICAL: Pass the bodyData from the endpoint to the request builder
        let request = try requestBuilder.buildRequest(
            from: endpoint,
            body: endpoint.bodyData
        )
        
        let (data, _) = try await client.execute(request)
        return try JSONDecoder().decode(LoginResponse.self, from: data)
    }
    
    // MARK: - Refresh Token
    /// Refreshes the access token using a refresh token
    /// - Parameter refreshToken: The current refresh token
    /// - Returns: LoginResponse with new access and refresh tokens
    func refreshToken(_ refreshToken: String) async throws -> LoginResponse {
        let endpoint = UserEndpoint.refresh(token: refreshToken)
        
        // ✅ CRITICAL: Pass the bodyData from the endpoint to the request builder
        let request = try requestBuilder.buildRequest(
            from: endpoint,
            body: endpoint.bodyData
        )
        
        let (data, _) = try await client.execute(request)
        return try JSONDecoder().decode(LoginResponse.self, from: data)
    }
}

// MARK: - Response Models
struct LoginResponse: Codable {
    let data: TokenData
    
    struct TokenData: Codable {
        let user: UserInfo
        let accessToken: String
        let refreshToken: String?
        
        struct UserInfo: Codable {
            let id: Int
            let email: String
            let firstName: String?
            let lastName: String?
        }
    }
}
