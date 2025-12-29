//  RegisterViewModel.swift
//  Traveling
//
// ONLY FOR EXAMPLE, DELETE OR CHANGE IT AFTER

import Foundation

/// ViewModel responsible for user registration logic.
class RegisterViewModel: ObservableObject {
    // MARK: - Properties
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var phone: String = ""
    @Published var didAttemptRegister = false
    @Published var registerState: RegisterViewModel.RegisterState = .idle

    // MARK: - Dependencies
    private let tokenManager: TokenManaging
    private let authService: AuthService
    private let userService: UserService

    // MARK: - Init
    /// Initializes a new instance of RegisterViewModel.
    /// - Parameters:
    ///   - authService: Authentication service. Default is `Services.auth`.
    ///   - userService: User service. Default is `Services.user`.
    ///   - tokenManager: Token manager. Default is `Services.tokenManager`.
    init(
        authService: AuthService = Services.auth,
        userService: UserService = Services.user,
        tokenManager: TokenManaging = Services.tokenManager
    ) {
        self.authService = authService
        self.userService = userService
        self.tokenManager = tokenManager
    }

    // MARK: - Methods
    func validateEmail() -> Bool {
        let regex = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"#
        let test = NSPredicate(format: "SELF MATCHES %@", regex)
        return test.evaluate(with: email)
    }

    func validatePassword() -> Bool {
        password.count >= 6 && password.count <= 255
    }

    var shouldShowEmailError: Bool {
        didAttemptRegister && !validateEmail()
    }

    var shouldShowPasswordError: Bool {
        didAttemptRegister && !validatePassword()
    }

    /// Starts the registration process.
    func register() async {
        didAttemptRegister = true
        registerState = .idle
        guard validateEmail(), validatePassword(), !firstName.isEmpty, !lastName.isEmpty, !phone.isEmpty else { return }
        do {
            registerState = .loading
            let response = try await authService.register(
                email: email,
                password: password,
                firstName: firstName,
                lastName: lastName,
                phone: phone
            )
            // Save token if needed
            let token = response.data.token
            // Here you could save the token if the app requires it
            registerState = .success
        } catch {
            registerState = .failure(error)
        }
    }
    
        // MARK: - RegisterState
        enum RegisterState: Equatable {
            case idle
            case loading
            case success
            case failure(Error)

            static func == (lhs: RegisterState, rhs: RegisterState) -> Bool {
                switch (lhs, rhs) {
                case (.idle, .idle), (.loading, .loading), (.success, .success):
                    return true
                case (.failure, .failure):
                    return true // Only for UI purposes, does not compare error values
                default:
                    return false
                }
            }
        }
}
