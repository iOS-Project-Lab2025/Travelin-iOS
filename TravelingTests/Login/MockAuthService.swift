//
//  MockAuthService.swift
//  TravelingTests
//
//  Created by Ivan Pereira on 17-12-25.
//

import Foundation
import Testing
@testable import Traveling

// MARK: - Mock AuthService

/// Mock implementation of AuthService for testing purposes
/// This is a standalone mock that implements AuthServiceProtocol
class MockAuthService: AuthServiceProtocol {
    var shouldSucceed = true
    var shouldThrowError = false
    var loginCallCount = 0
    var lastEmail: String?
    var lastPassword: String?

    enum MockAuthError: Error {
        case invalidCredentials
        case networkError
    }

    func login(email: String, password: String) async throws -> LoginResponse {
        loginCallCount += 1
        lastEmail = email
        lastPassword = password

        if shouldThrowError {
            throw MockAuthError.invalidCredentials
        }

        if shouldSucceed {
            return LoginResponse(
                data: LoginResponse.TokenData(
                    user: LoginResponse.TokenData.UserInfo(
                        id: 1,
                        email: email,
                        firstName: "Test",
                        lastName: "User"
                    ),
                    accessToken: "mock_access_token",
                    refreshToken: "mock_refresh_token"
                )
            )
        }

        throw MockAuthError.networkError
    }

    func refreshToken(_ refreshToken: String) async throws -> LoginResponse {
        // Not used in login tests
        fatalError("refreshToken not implemented in mock")
    }
}
