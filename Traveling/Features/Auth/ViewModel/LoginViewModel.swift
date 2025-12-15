//
//  LoginViewModel.swift
//  Traveling
//
//  Created by Ivan Pereira on 03-12-25.
//

import Foundation

@Observable
class LoginViewModel: LoginViewModelProtocol {

    var email: String = ""
    var password: String = ""

    var didAttemptLogin = false
    var loginState: LoginState = .idle

    private let tokenManager: TokenManaging
    private let authService: AuthService
    private let userService: UserService

    init(
        authService: AuthService = Services.auth,
        userService: UserService = Services.user,
        tokenManager: TokenManaging = Services.tokenManager
    ) {
        self.authService = authService
        self.userService = userService
        self.tokenManager = tokenManager
    }

    func validateEmail() -> Bool {
        let regex = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        let test = NSPredicate(format: "SELF MATCHES %@", regex)
        return test.evaluate(with: email)
    }

    func validatePassword() -> Bool {
        !password.isEmpty
    }

    var shouldShowEmailError: Bool {
        didAttemptLogin && !validateEmail()
    }

    var shouldShowPasswordError: Bool {
        didAttemptLogin && !validatePassword()
    }

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
