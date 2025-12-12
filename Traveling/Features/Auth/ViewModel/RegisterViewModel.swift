//
//  RegisterVIewModel.swift
//  Traveling
//
//  Created by NVSH on 09-12-25.
//
import Foundation

@Observable
class RegisterViewModel: RegisterViewModelProtocol {
    var firstName: String = ""
    var lastName: String = ""
    var phone: String = ""
    var age: any Numeric = 0
    var email: String = ""
    var password: String = ""

    func createAccount() {
        print("""
            Account Created:
            First Name: \(firstName)
            Last Name: \(lastName)
            Phone: \(phone)
            Age: \(age)
            Email: \(email)
            Password: \(password)
            """)
    }

}
