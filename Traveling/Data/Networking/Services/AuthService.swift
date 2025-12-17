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

        let (data, response) = try await client.execute(request)

        if let httpResponse = response as? HTTPURLResponse,
           !(200...299).contains(httpResponse.statusCode) {

            if let errorResponse = try? JSONDecoder().decode(LoginErrorResponse.self, from: data),
               let firstError = errorResponse.errors.first {
                throw NetworkingError.serverError(code: firstError.status, message: firstError.detail)
            } else {
                throw NetworkingError.serverError(code: httpResponse.statusCode, message: "Unknown server error")
            }
        }

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

        let (data, response) = try await client.execute(request)

        if let httpResponse = response as? HTTPURLResponse,
           !(200...299).contains(httpResponse.statusCode) {

            if let errorResponse = try? JSONDecoder().decode(LoginErrorResponse.self, from: data),
               let firstError = errorResponse.errors.first {
                throw NetworkingError.serverError(code: firstError.status, message: firstError.detail)
            } else {
                throw NetworkingError.serverError(code: httpResponse.statusCode, message: "Unknown server error")
            }
        }

        return try JSONDecoder().decode(LoginResponse.self, from: data)
    }
}
