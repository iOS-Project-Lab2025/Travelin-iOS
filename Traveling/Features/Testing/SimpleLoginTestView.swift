//
//  SimpleLoginTestView.swift
//  Traveling
//
//  Created by Daniel Retamal on 04-12-25.
//
//  TESTING VIEW - Simple login flow demonstration
//  Shows basic authentication flow with email/password and displays user profile
//

import SwiftUI

/// ViewModel to handle login test logic
@MainActor
class SimpleLoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoggedIn: Bool = false
    @Published var userInfo: String = ""
    @Published var errorMessage: String = ""
    @Published var isLoading: Bool = false

    // Dependencies (injected, defaults from Services)
    private let tokenManager: TokenManaging
    private let authService: AuthService
    private let userService: UserService

    /// Initializes the view model with dependency injection
    /// - Parameters:
    ///   - authService: Service for authentication (default: Services.auth)
    ///   - userService: Service for user operations (default: Services.user)
    ///   - tokenManager: Token storage manager (default: Services.tokenManager)
    init(
        authService: AuthService = Services.auth,
        userService: UserService = Services.user,
        tokenManager: TokenManaging = Services.tokenManager
    ) {
        self.authService = authService
        self.userService = userService
        self.tokenManager = tokenManager
    }

    /// Performs login and fetches user profile
    func login() async {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please enter email and password"
            return
        }

        isLoading = true
        errorMessage = ""

        do {
            // 1. Login to get tokens
            print("🔵 LOGIN DEBUG - Starting login process")
            print("🔵 Email: \(email)")
            print("🔵 Password: \(password)")

            let loginResponse = try await authService.login(email: email, password: password)

            print("🟢 LOGIN DEBUG - Response received successfully")
            print("🟢 Access Token: \(loginResponse.data.accessToken.prefix(20))...")
            if let refresh = loginResponse.data.refreshToken {
                print("🟢 Refresh Token: \(refresh.prefix(20))...")
            }

            // 2. Save tokens to Keychain
            let tokens = OAuthTokens(
                accessToken: loginResponse.data.accessToken,
                refreshToken: loginResponse.data.refreshToken
            )
            try tokenManager.saveTokens(tokens)

            // 3. Update UI with user info from login response
            isLoggedIn = true
            userInfo = formatUserInfoFromLogin(loginResponse.data)

        } catch {
            errorMessage = "Login failed: \(error.localizedDescription)"
        }

        isLoading = false
    }

    /// Logs out and clears stored tokens
    func logout() {
        tokenManager.clearTokens()
        isLoggedIn = false
        userInfo = ""
        email = ""
        password = ""
        errorMessage = ""
    }

    /// Formats user info from login response
    private func formatUserInfoFromLogin(_ data: LoginResponse.TokenData) -> String {
        var info = "✓ Login Successful\n\n"
        info += "User ID: \(data.user.id)\n"
        info += "Email: \(data.user.email)\n"

        if let firstName = data.user.firstName {
            info += "First Name: \(firstName)\n"
        }

        if let lastName = data.user.lastName {
            info += "Last Name: \(lastName)\n"
        }

        return info
    }
}

// MARK: - View

struct SimpleLoginTestView: View {
    @StateObject private var viewModel = SimpleLoginViewModel()

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                if !viewModel.isLoggedIn {
                    // Login Form
                    loginFormView
                } else {
                    // User Profile Display
                    profileView
                }
            }
            .padding()
            .navigationTitle("Login Test")
        }
    }

    // MARK: - Login Form
    private var loginFormView: some View {
        VStack(spacing: 20) {
            Text("Test Login")
                .font(.title2)
                .fontWeight(.bold)

            // Email Field
            TextField("Email", text: $viewModel.email)
                .textContentType(.emailAddress)
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
                .textFieldStyle(.roundedBorder)

            // Password Field
            SecureField("Password", text: $viewModel.password)
                .textContentType(.password)
                .textFieldStyle(.roundedBorder)

            // Error Message
            if !viewModel.errorMessage.isEmpty {
                Text(viewModel.errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
                    .multilineTextAlignment(.center)
            }

            // Login Button
            Button {
                Task {
                    await viewModel.login()
                }
            } label: {
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text("Login")
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .disabled(viewModel.isLoading)

            Spacer()
        }
    }

    // MARK: - Profile View
    private var profileView: some View {
        VStack(spacing: 20) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 60))
                .foregroundColor(.green)

            Text(viewModel.userInfo)
                .font(.body)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)

            Spacer()

            Button("Logout") {
                viewModel.logout()
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
    }
}

// MARK: - Preview

#Preview {
    SimpleLoginTestView()
}
