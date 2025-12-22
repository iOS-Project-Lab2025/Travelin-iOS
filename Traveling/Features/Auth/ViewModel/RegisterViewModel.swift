//
//  RegisterViewModel.swift
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
    var selectedPhoneCode: PhoneCountryCode
    var availableCountryCodes: [PhoneCountryCode]
    var email: String = ""
    var password: String = ""

    // Validation states
    var isEmailValid: Bool {
        email.isEmpty || TextValidators.isValidEmail(email)
    }

    var emailErrorMessage: String? {
        if email.isEmpty {
            return nil
        }
        return isEmailValid ? nil : "Please enter a valid email address"
    }

    var passwordStrength: TextValidators.PasswordStrength? {
        guard !password.isEmpty else { return nil }
        return TextValidators.validatePasswordStrength(password)
    }

    var isFormValid: Bool {
        return !firstName.isEmpty &&
               !lastName.isEmpty &&
               !phone.isEmpty &&
               phone.count == selectedPhoneCode.maxDigits &&
               !email.isEmpty &&
               TextValidators.isValidEmail(email) &&
               !password.isEmpty &&
               (passwordStrength?.isValid ?? false)
    }

    // MARK: - Init
    init() {
        self.availableCountryCodes = PhoneCountryCodeData.getAllCountryCodes()
        self.selectedPhoneCode = PhoneCountryCodeData.getDefaultCountryCode()
    }

    // MARK: - Update Methods with Validation

    func updateFirstName(_ newValue: String) {
        firstName = TextValidators.validateName(newValue)
    }

    func updateLastName(_ newValue: String) {
        lastName = TextValidators.validateName(newValue)
    }

    func updatePhone(_ newValue: String) {
        let filtered = TextValidators.validatePhone(newValue)
        let maxDigits = selectedPhoneCode.maxDigits

        if filtered.count > maxDigits {
            phone = String(filtered.prefix(maxDigits))
        } else {
            phone = filtered
        }
    }

    func updateEmail(_ newValue: String) {
        email = newValue.trimmingCharacters(in: .whitespaces)
    }

    func updatePassword(_ newValue: String) {
        password = newValue
    }

    func updateSelectedCountryCode(_ code: String) {
        if let newCode = PhoneCountryCodeData.getCountryCode(by: code) {
            selectedPhoneCode = newCode
            updatePhone(phone)
        }
    }

    func createAccount() {
        guard isFormValid else {
            print("Form is not valid")
            return
        }

        let fullPhone = "\(selectedPhoneCode.code)\(phone)"
        print("""
            Account Created:
            First Name: \(firstName)
            Last Name: \(lastName)
            Phone: \(fullPhone)
            Email: \(email)
            Password: [HIDDEN]
            """)
    }
}
