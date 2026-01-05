//
//  LoginViewModel.swift
//  Traveling
//
//  Created by Ivan Pereira on 03-12-25.
//

import Foundation

/// A view model responsible for handling the logic of the Login screen.
///
/// This class manages the state of the login form, including validation and authentication.
@Observable
class LoginViewModel: LoginViewModelProtocol {

    // MARK: - Properties

    /// The email address entered by the user.
    var email: String = ""
    /// The password entered by the user.
    var password: String = ""

    /// A flag indicating if the user has attempted to login.
    var didAttemptLogin = false
    /// The current state of the login process.
    var loginState: LoginState = .idle

    // MARK: - Dependencies

    private let tokenManager: TokenManaging
    private let authService: AuthServiceProtocol
    private let userService: UserServiceProtocol

    // MARK: - Init

    /// Initializes a new instance of `LoginViewModel`.
    ///
    /// - Parameters:
    ///   - authService: The service responsible for authentication. Defaults to `Services.auth`.
    ///   - userService: The service responsible for user management. Defaults to `Services.user`.
    ///   - tokenManager: The manager for handling tokens. Defaults to `Services.tokenManager`.
    init(
        authService: AuthServiceProtocol = Services.auth,
        userService: UserServiceProtocol = Services.user,
        tokenManager: TokenManaging = Services.tokenManager
    ) {
        self.authService = authService
        self.userService = userService
        self.tokenManager = tokenManager
    }

    // MARK: - Methods

    /// Validates the email address format.
    ///
    /// - Returns: `true` if the email matches the standard email regex, `false` otherwise.
    func validateEmail() -> Bool {
        let regex = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        let test = NSPredicate(format: "SELF MATCHES %@", regex)
        return test.evaluate(with: email)
    }

    /// Validates the password.
    ///
    /// - Returns: `true` if the password is not empty, `false` otherwise.
    func validatePassword() -> Bool {
        !password.isEmpty
    }

    var shouldShowEmailError: Bool {
        didAttemptLogin && !validateEmail()
    }

    var shouldShowPasswordError: Bool {
        didAttemptLogin && !validatePassword()
    }

    /// Initiates the login process.
    ///
    /// This method performs the following steps:
    /// 1. Validates the email and password.
    /// 2. Sets the state to `.loading`.
    /// 3. Calls the authentication service.
    /// 4. Saves the tokens upon success and sets state to `.success`.
    /// 5. Sets state to `.failure` if an error occurs.
    func login() async {
        didAttemptLogin = true
        loginState = .idle
        guard validateEmail(), validatePassword() else {
            return
        }
        print("Login... email: \(email), password: \(password)")

        do {
            loginState = .loading
            let  loginResponse = try await authService.login(email: email, password: password)

            if let refresh = loginResponse.data.refreshToken {
                print("🟢 Refresh Token: \(refresh.prefix(20))...")
            }

            let tokens = OAuthTokens(
                accessToken: loginResponse.data.accessToken,
                refreshToken: loginResponse.data.refreshToken
            )
            try tokenManager.saveTokens(tokens)

            loginState = .success

        } catch {
        loginState = .failure(error)
        }
    }

}
