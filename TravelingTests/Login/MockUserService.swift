//
//  MockUserService.swift
//  TravelingTests
//
//  Created by Ivan Pereira on 17-12-25.
//

import Testing
@testable import Traveling

// MARK: - Mock UserService

/// Mock implementation of UserService for testing purposes
/// This is a standalone mock that implements UserServiceProtocol
class MockUserService: UserServiceProtocol {
    func getUserProfile() async throws -> UserProfileResponse {
        // Not used in login tests
        fatalError("getUserProfile not implemented in mock")
    }
}
