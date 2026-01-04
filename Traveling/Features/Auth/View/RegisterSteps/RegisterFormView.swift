//  RegisterFormView.swift
//  Traveling
//
//  Created by Ignacio Alvarado on 09-12-25.
//

import SwiftUI
import TravelinDesignSystem

struct RegisterFormView: View {

    // MARK: - Dependencies
    @Environment(AppRouter.FlowRouter<RegisterRoutes>.self) private var registerRouter
    @Environment(\.appRouter) private var mainRouter

    // MARK: - State
    @ObservedObject private var registerViewModel: RegisterViewModel

    // MARK: - Init
    init(registerViewModel: RegisterViewModel) {
        self.registerViewModel = registerViewModel
    }

    // MARK: - Body
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                header
                form
                footer
            }
            .padding(.horizontal, 24)
            .padding(.top, 10)
        }
        .navigationBarHidden(true)
        .onChange(of: registerViewModel.state) { _, newState in
            if case .success = newState {
                registerRouter.next()
            }
        }
    }

    // MARK: - Components
    
    private var header: some View {
        VStack(alignment: .leading, spacing: 20) {
            Button {
                mainRouter.goTo(.home)
            }
            label: {
                    Image(systemName: "chevron.left")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.black)
            }
            .padding(.horizontal, 26)
            .frame(maxWidth: .infinity, alignment: .leading)

            VStack(alignment: .leading, spacing: 8) {
                Text("register.TitleText".localized)
                    .font(TravelinDesignSystem.DesignTokens.Typography.heading1)
                    .foregroundColor(.black)

                Text("register.subTitleText".localized)
                    .font(TravelinDesignSystem.DesignTokens.Typography.body)
                    .foregroundColor(TravelinDesignSystem.DesignTokens.Colors.secondaryText)
            }
        }
    }

    private var form: some View {
        VStack(spacing: 16) {

            // First Name
            DSTextField(
                placeHolder: "register.firstNamePlaceHolder".localized,
                type: .givenName,
                label: "register.firstNameTextFieldLabel".localized,
                style: .outlined,
                text: $registerViewModel.firstName
            )

            // Last Name
            DSTextField(
                placeHolder: "register.lastNamePlaceHolder".localized,
                type: .familyName,
                label: "register.lastNameTextFieldLabel".localized,
                style: .outlined,
                text: $registerViewModel.lastName
            )

            // Phone number
            HStack(spacing: 12) {
                DSDropDown(
                    items: registerViewModel.availableCountryCodes.map { $0.code },
                    selectedItem: Binding(
                        get: { registerViewModel.selectedPhoneCode.code },
                        set: { newCode in
                            registerViewModel.updateSelectedCountryCode(newCode)
                        }
                    )
                )
                .frame(width: 100)

                DSTextField(
                    placeHolder: "register.phonePlaceHolder".localized,
                    type: .phoneNumber,
                    style: .outlined,
                    text: $registerViewModel.phone
                )
            }
            .zIndex(1)

            // Email Section
            VStack(alignment: .leading, spacing: 4) {
                DSTextField(
                    placeHolder: "register.emailPlaceHolder".localized,
                    type: .email,
                    label: "register.emailTextFieldLabel".localized,
                    style: .outlined,
                    text: $registerViewModel.email
                )

                if let errorMessage = registerViewModel.emailErrorMessage {
                    Text(errorMessage)
                        .font(TravelinDesignSystem.DesignTokens.Typography.body)
                        .foregroundColor(TravelinDesignSystem.DesignTokens.Colors.error)
                        .padding(.leading, 4)
                        .transition(.opacity)
                }
            }

            // Password Section
            VStack(alignment: .leading, spacing: 8) {
                DSTextField(
                    placeHolder: "register.passwordPlaceHolder".localized,
                    type: .passwordLetters,
                    label: "register.passwordTextFieldLabel".localized,
                    style: .outlined,
                    text: $registerViewModel.password
                )

                // Barra de fuerza
                if let strength = registerViewModel.passwordStrength {
                    passwordStrengthView(strength: strength)
                }
            }

            Spacer().frame(height: 20)

            // Server Error
            if case .failure(let error) = registerViewModel.state {
                Text(error.localizedDescription)
                    .font(TravelinDesignSystem.DesignTokens.Typography.body)
                    .foregroundColor(TravelinDesignSystem.DesignTokens.Colors.error)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 8)
            }

            Spacer().frame(height: 20)

            // Action Button
            ZStack {
                DSButton(
                    title: registerViewModel.state == .loading ? "" : "register.createAccountButtonTitle".localized,
                    variant: .primary
                ) {
                    registerViewModel.createAccount()
                }
                .disabled(!registerViewModel.isFormValid || registerViewModel.state == .loading)
                .opacity((registerViewModel.isFormValid && registerViewModel.state != .loading) ? 1.0 : 0.5)

                if registerViewModel.state == .loading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                }
            }
        }
    }

    private var footer: some View {
        HStack {
            Text("register.footerText".localized)
                .font(TravelinDesignSystem.DesignTokens.Typography.body)
                .foregroundColor(TravelinDesignSystem.DesignTokens.Colors.secondaryText)

            Button(action: {
                mainRouter.goTo(.authentication(.login))
            }, label: {
                Text("register.footerButtonLogin".localized)
                    .font(TravelinDesignSystem.DesignTokens.Typography.bodyBold)
                    .foregroundColor(TravelinDesignSystem.DesignTokens.Colors.linkText)
            })
        }
        .padding(.bottom, 20)
    }

    private func passwordStrengthView(strength: TextValidators.PasswordStrength) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 8) {
                ForEach(0..<5, id: \.self) { index in
                    Rectangle()
                        .fill(calculateStrengthBarColor(strength: strength, index: index))
                        .frame(height: 4)
                        .cornerRadius(2)
                }
            }

            if !strength.isValid {
                Text(strength.message ?? "register.passwordStrength".localized) // Safety unwrap
                    .font(TravelinDesignSystem.DesignTokens.Typography.body)
                    .foregroundColor(TravelinDesignSystem.DesignTokens.Colors.secondaryText)
            }
        }
        .padding(.horizontal, 4)
    }

    private func calculateStrengthBarColor(strength: TextValidators.PasswordStrength, index: Int) -> Color {
        let validCount = [strength.hasMinLength, strength.hasUppercase, strength.hasLowercase, strength.hasNumber, strength.hasSpecialChar].filter {$0}.count
        if index < validCount {
            switch validCount {
            case 1...2: return .red
            case 3: return .orange
            case 4: return .yellow
            case 5: return .green
            default: return .gray.opacity(0.3)
            }
        }
        return .gray.opacity(0.3)
    }
}

#Preview {
    let viewModel = RegisterViewModel()

    RegisterFormView(registerViewModel: viewModel)
        .environment(AppRouter.FlowRouter<RegisterRoutes>(flow: [.form, .success]))
}
