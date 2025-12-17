//
//  LoginState.swift
//  Traveling
//
//  Created by Ivan Pereira on 15-12-25.
//

import Foundation

/// Represents the various states of the login process.
enum LoginState {

    // MARK: - Cases
    /// The initial state when the user is not attempting to login.
    case idle
    /// The state when a login request is in progress.
    case loading
    /// The state when login was successful.
    case success
    /// The state when login failed with an error.
    /// - Parameter Error: The error that occurred during login.
    case failure(Error)
}
