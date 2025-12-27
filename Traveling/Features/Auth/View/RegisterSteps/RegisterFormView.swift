//
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
    @State private var registerViewModel: any RegisterViewModelProtocol

    // MARK: - Init
    init(registerViewModel: any RegisterViewModelProtocol) {
        _registerViewModel = State(initialValue: registerViewModel)
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
    }

    // MARK: - Components
    private var header: some View {
        VStack(alignment: .leading, spacing: 20) {
            Button(action: {
                mainRouter.goTo(.home)
            }, label: {
                Image(systemName: "arrow.left")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.black)
                    .padding(10)
                    .background(
                        Circle()
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
            })
            .frame(maxWidth: .infinity, alignment: .leading)

            VStack(alignment: .leading, spacing: 8) {
                Text("Create Account")
                    .font(TravelinDesignSystem.DesignTokens.Typography.heading1)
                    .foregroundColor(.black)

                Text("Get the best out of Traveling by creating an account")
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
                
                // Error Message View
                if let errorMessage = registerViewModel.emailErrorMessage {
                    Text(errorMessage)
                        .font(TravelinDesignSystem.DesignTokens.Typography.body)
                        .foregroundColor(TravelinDesignSystem.DesignTokens.Colors.error)
                        .padding(.leading, 4)
                        .transition(.opacity) // Animación suave
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

                if let strength = registerViewModel.passwordStrength {
                    passwordStrengthView(strength: strength)
                }
            }

            Spacer().frame(height: 20)

            // Action Button
            DSButton(
                title: "register.createAccountButtonTitle".localized,
                variant: .primary
            ) {
                registerViewModel.createAccount()
                Task {

                    registerRouter.next()
                }
            }
            .disabled(!registerViewModel.isFormValid)
            .opacity(registerViewModel.isFormValid ? 1.0 : 0.5)
        }
    }

    private var footer: some View {
        HStack {
            Text("Already have an account?")
                .font(TravelinDesignSystem.DesignTokens.Typography.body)
                .foregroundColor(TravelinDesignSystem.DesignTokens.Colors.secondaryText)

            Button(action: {
                mainRouter.goTo(.authentication(.login))
            }, label: {
                Text("Log In")
                    .font(TravelinDesignSystem.DesignTokens.Typography.bodyBold)
                    .foregroundColor(TravelinDesignSystem.DesignTokens.Colors.linkText)
            })
        }
        .padding(.bottom, 20)
    }
    
    // MARK: - Subviews
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
                Text(strength.message)
                    .font(TravelinDesignSystem.DesignTokens.Typography.body)
                    .foregroundColor(TravelinDesignSystem.DesignTokens.Colors.secondaryText)
            }
        }
        .padding(.horizontal, 4)
    }
    
    private func calculateStrengthBarColor(strength: TextValidators.PasswordStrength, index: Int) -> Color {
        let validCount = [strength.hasMinLength, strength.hasUppercase, strength.hasLowercase, strength.hasNumber, strength.hasSpecialChar].filter{$0}.count
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
    // 1. Necesitas una versión "Mock" o de prueba de tu ViewModel
    // Si no tienes una clase Mock, puedes usar la real con datos vacíos por ahora
    RegisterFormView(registerViewModel: RegisterViewModel())
       
}
