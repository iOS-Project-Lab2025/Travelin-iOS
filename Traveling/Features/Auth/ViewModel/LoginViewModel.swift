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

    func login() {
        print("Login... email: \(email), password: \(password)")
    }

}
