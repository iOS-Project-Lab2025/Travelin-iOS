//
//  AuthServiceProtocol.swift
//  Traveling
//
//  Created by Ivan Pereira on 17-12-25.
//

import Foundation

/// Protocol defining the authentication service interface
protocol AuthServiceProtocol {
    /// Performs user login with email and password
    /// - Parameters:
    ///   - email: User's email
    ///   - password: User's password
    /// - Returns: LoginResponse containing access and refresh tokens
    func login(email: String, password: String) async throws -> LoginResponse

    /// Refreshes the access token using a refresh token
    /// - Parameter refreshToken: The current refresh token
    /// - Returns: LoginResponse with new access and refresh tokens
    func refreshToken(_ refreshToken: String) async throws -> LoginResponse
}

/// Conformance of AuthService to the protocol
extension AuthService: AuthServiceProtocol {}
