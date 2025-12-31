//
//  UserServiceProtocol.swift
//  Traveling
//
//  Created by Ivan Pereira on 17-12-25.
//

import Foundation

/// Protocol defining the user service interface
protocol UserServiceProtocol {
    /// Fetches the current user's profile information
    /// - Returns: UserProfileResponse containing user data
    func getUserProfile() async throws -> UserProfileResponse
}

/// Conformance of UserService to the protocol
extension UserService: UserServiceProtocol {}
