//
//  LoginViewModelProtocol.swift
//  Traveling
//
//  Created by Ivan Pereira on 05-12-25.
//

import Foundation

/// Protocol defining the interface for the Login ViewModel.
///
/// Use this protocol to implement the view model for the Login screen, ensuring testability and separation of concerns.
protocol LoginViewModelProtocol: Observable {

    // MARK: - Properties
    /// The email address entered by the user.
    var email: String { get set }
    /// The password entered by the user.
    var password: String { get set }
    /// A flag indicating if the user has attempted to login.
    var didAttemptLogin: Bool { get set }
    /// The current state of the login process.
    var loginState: LoginState { get }

    // MARK: - Methods

    /// Validates the email address.
    /// - Returns: `true` if the email is valid, `false` otherwise.
    func validateEmail() -> Bool
    /// Validates the password.
    /// - Returns: `true` if the password is valid, `false` otherwise.
    func validatePassword() -> Bool

    /// Indicates whether the email error message should be displayed.
    var shouldShowEmailError: Bool { get }
    /// Indicates whether the password error message should be displayed.
    var shouldShowPasswordError: Bool { get }

    /// Initiates the login process.
    ///
    /// This method validates the inputs and attempts to authenticate with the server.
    func login() async
}
