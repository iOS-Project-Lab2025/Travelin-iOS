//
//  RegisterViewModelProtocol.swift
//  Traveling
//
//  Created by NVSH on 09-12-25.
//
import Foundation

protocol RegisterViewModelProtocol: ObservableObject {
    
    var firstName: String { get set }
    var lastName: String { get set }
    var phone: String { get set }
    var selectedPhoneCode: PhoneCountryCode { get set }
    var availableCountryCodes: [PhoneCountryCode] { get set }
    var email: String { get set }
    var password: String { get set}
    var state: RegisterState { get }

    // Validation states
    var isEmailValid: Bool { get }
    var emailErrorMessage: String? { get }
    var passwordStrength: TextValidators.PasswordStrength? { get }
    var isFormValid: Bool { get }

    // Update methods
    func updateFirstName(_ newValue: String)
    func updateLastName(_ newValue: String)
    func updatePhone(_ newValue: String)
    func updateEmail(_ newValue: String)
    func updatePassword(_ newValue: String)
    func updateSelectedCountryCode(_ code: String)

    func createAccount()
}
