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

    func login() {
        didAttemptLogin = true

        guard validateEmail(), validatePassword() else {
            return
        }
        print("Login... email: \(email), password: \(password)")
    }

}
