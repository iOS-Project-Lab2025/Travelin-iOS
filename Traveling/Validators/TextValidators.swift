//
//  TextValidators.swift
//  Traveling
//
//  Created by NVSH on 12-12-25.
//

import Foundation

struct TextValidators {

    // MARK: - Name Validation
    static func validateName(_ text: String) -> String {
        let allowedCharacters = CharacterSet.letters.union(.whitespaces)
        let filtered = text.unicodeScalars.filter { allowedCharacters.contains($0) }
        return String(String.UnicodeScalarView(filtered))
    }

    // MARK: - Email Validation
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }

    // MARK: - Phone Validation
    static func validatePhone(_ text: String) -> String {
        return text.filter { $0.isNumber }
    }

    // MARK: - Password Validation
    struct PasswordStrength {
        let isValid: Bool
        let hasMinLength: Bool
        let hasUppercase: Bool
        let hasLowercase: Bool
        let hasNumber: Bool
        let hasSpecialChar: Bool

        var message: String {
            if !hasMinLength { return "Password must be at least 8 characters" }
            if !hasUppercase { return "Password must contain an uppercase letter" }
            if !hasLowercase { return "Password must contain a lowercase letter" }
            if !hasNumber { return "Password must contain a number" }
            if !hasSpecialChar { return "Password must contain a special character" }
            return "Password is strong"
        }
    }

    static func validatePasswordStrength(_ password: String, minLength: Int = 8) -> PasswordStrength {
        let hasMinLength = password.count >= minLength
        let hasUppercase = password.rangeOfCharacter(from: .uppercaseLetters) != nil
        let hasLowercase = password.rangeOfCharacter(from: .lowercaseLetters) != nil
        let hasNumber = password.rangeOfCharacter(from: .decimalDigits) != nil
        let hasSpecialChar = password.rangeOfCharacter(from: CharacterSet(charactersIn: "!@#$%^&*()_+-=[]{}|;:',.<>?")) != nil

        let isValid = hasMinLength && hasUppercase && hasLowercase && hasNumber && hasSpecialChar

        return PasswordStrength(
            isValid: isValid,
            hasMinLength: hasMinLength,
            hasUppercase: hasUppercase,
            hasLowercase: hasLowercase,
            hasNumber: hasNumber,
            hasSpecialChar: hasSpecialChar
        )
    }
}
