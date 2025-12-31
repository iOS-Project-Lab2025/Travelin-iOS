//  RegisterViewModel.swift
//  Traveling
//
//  Created by Ignacio Alvarado on 09-12-25.
//

import Foundation
import Combine
import TravelinDesignSystem

@MainActor
class RegisterViewModel: RegisterViewModelProtocol, ObservableObject {

    // MARK: - Properties (Inputs)
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var phone: String = ""
    @Published var email: String = ""
    @Published var password: String = ""

    // MARK: - Properties (Selectores)
    @Published var selectedPhoneCode: PhoneCountryCode
    @Published var availableCountryCodes: [PhoneCountryCode]

    // MARK: - State
    @Published var state: RegisterState = .idle

    // MARK: - Dependencies
    private let tokenManager: TokenManaging
    private let authService: AuthService
    private let userService: UserService

    // MARK: - Computed Properties (Validations)

    var isEmailValid: Bool {
        let regex = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let test = NSPredicate(format: "SELF MATCHES %@", regex)
        return test.evaluate(with: email)
    }

    var emailErrorMessage: String? {
        guard !email.isEmpty else { return nil }
        return isEmailValid ? nil : "Email inválido"
    }

    var passwordStrength: TextValidators.PasswordStrength? {
        guard !password.isEmpty else { return nil }

        let hasMinLength = password.count >= 8
        let hasUppercase = password.range(of: "[A-Z]", options: .regularExpression) != nil
        let hasLowercase = password.range(of: "[a-z]", options: .regularExpression) != nil
        let hasNumber = password.range(of: "[0-9]", options: .regularExpression) != nil
        let hasSpecialChar = password.range(of: "[^A-Za-z0-9]", options: .regularExpression) != nil
        let isValid = hasMinLength && hasUppercase && hasLowercase && hasNumber && hasSpecialChar

        // Asumiendo que corregiste el init de PasswordStrength en tu librería
        return TextValidators.PasswordStrength(
            isValid: isValid,
            hasMinLength: hasMinLength,
            hasUppercase: hasUppercase,
            hasLowercase: hasLowercase,
            hasNumber: hasNumber,
            hasSpecialChar: hasSpecialChar
        )
    }

    var isFormValid: Bool {
        return isEmailValid &&
               (passwordStrength?.isValid ?? false) &&
               !firstName.isEmpty &&
               !lastName.isEmpty &&
               !phone.isEmpty
    }

    // MARK: - Init
    init(
        authService: AuthService = Services.auth,
        userService: UserService = Services.user,
        tokenManager: TokenManaging = Services.tokenManager
    ) {
        self.authService = authService
        self.userService = userService
        self.tokenManager = tokenManager

        // Inicializamos los códigos de país (Mock data)
        let chile = PhoneCountryCode(code: "+56", maxDigits: 9, country: "Chile")
        let usa = PhoneCountryCode(code: "+1", maxDigits: 10, country: "USA")
        let argentina = PhoneCountryCode(code: "+54", maxDigits: 10, country: "Argentina")

        self.availableCountryCodes = [chile, usa, argentina]
        self.selectedPhoneCode = chile
    }

    // MARK: - Update Methods (Requeridos por el Protocolo)

    func updateFirstName(_ newValue: String) {
        firstName = newValue
    }

    func updateLastName(_ newValue: String) {
        lastName = newValue
    }

    func updatePhone(_ newValue: String) {
        // Aquí podrías agregar lógica extra, ej: limitar caracteres según maxDigits
        if newValue.count <= selectedPhoneCode.maxDigits {
            phone = newValue
        }
    }

    func updateEmail(_ newValue: String) {
        email = newValue
    }

    func updatePassword(_ newValue: String) {
        password = newValue
    }

    func updateSelectedCountryCode(_ code: String) {
        if let found = availableCountryCodes.first(where: { $0.code == code }) {
            selectedPhoneCode = found
            // Opcional: Limpiar el teléfono si cambia el país
            // phone = ""
        }
    }

    // MARK: - Action Methods

    func createAccount() {
        print("🔘 Botón presionado. Verificando validaciones...")

        // Imprimimos el estado de cada validación
        print(" - Email válido: \(isEmailValid)")
        print(" - Password segura: \(passwordStrength?.isValid ?? false)")
        print(" - Nombre no vacío: \(!firstName.isEmpty)")
        print(" - Apellido no vacío: \(!lastName.isEmpty)")
        print(" - Teléfono no vacío: \(!phone.isEmpty)")

        // Si esto es falso, la función muere aquí
        guard isFormValid else {
            print("❌ ERROR: El formulario no es válido. La función se detiene.")
            return
        }

        print("✅ Formulario válido. Iniciando carga...")
        state = .loading

        Task {
            print("🚀 Iniciando llamada al servicio...")
            do {
                let fullPhone = "\(selectedPhoneCode.code)\(phone)"
                print("📞 Enviando teléfono: \(fullPhone)")

                let response = try await authService.register(
                    email: email,
                    password: password,
                    firstName: firstName,
                    lastName: lastName,
                    phone: fullPhone
                )

                print("✅ Respuesta exitosa del servidor: \(response)")
                self.state = .success

            } catch {
                print("❌ Error del servidor: \(error)")
                self.state = .failure(error)
            }
        }
    }
}
