//
//  LoginView.swift
//  Traveling
//
//  Created by Ivan Pereira on 21-11-25.
//

import SwiftUI
import TravelinDesignSystem

struct LoginView <VM: LoginViewModelProtocol>: View {
    @Environment(\.appRouter) var appRouter
    @State private var loginViewModel: VM

    init( loginViewModel: VM ) {
        self.loginViewModel = loginViewModel
    }

    // MARK: - Body sections
    var body: some View {

        VStack {
            header
            form
            footer
        }
    }

    // MARK: - Header
    private var header: some View {
        VStack {
            Spacer()
                .frame(height: 70)

            Image("AppLogoBlue")
                .resizable()
                .frame(
                    width: 103,
                    height: 102
                )
            Text("login.title".localized)
                .font(TravelinDesignSystem.DesignTokens.Typography.heading2)

            Text("login.subtitle".localized)
                .font(TravelinDesignSystem.DesignTokens.Typography.body)
        }
    }

    // MARK: - Form
    private var form: some View {
        VStack {
            DSTextField(
                placeHolder: "login.emailPlaceHolder".localized,
                type: .email,
                label: "login.emailTextFieldLabel".localized,
                style: .outlined,
                text: $loginViewModel.email)

            Text("login.emailError")
                .font(.system(size: 10))
                .foregroundColor(DesignTokens.Colors.error)
                .opacity(loginViewModel.shouldShowEmailError ? 1 : 0)
                .frame(maxWidth: .infinity, alignment: .leading)

            DSTextField(
                placeHolder: "login.passwordPlaceHolder".localized,
                 type: .passwordLetters,
                label: "login.passwordTextFieldLabel".localized,
                 style: .outlined,
                 text: $loginViewModel.password
             )
            .padding(.top, 2)
            Text("login.passwordError")
                .font(.system(size: 10))
                .foregroundColor(DesignTokens.Colors.error)
                .opacity(loginViewModel.shouldShowPasswordError ? 1 : 0)
                .frame(maxWidth: .infinity, alignment: .leading)

            DSButton(title: "login.loginButtonTitle".localized, variant: .primary) {
                loginViewModel.login()
            }
            .padding(.top, 10)
            Spacer()
                .frame(height: 187)
        }
        .padding(26)

    }

    // MARK: - Footer
    private var footer: some View {
        HStack {
            Text("login.footerText".localized)
                .font(DesignTokens.Typography.link)
                .fontWeight(.light)

            Button {
                appRouter.goTo(.authentication(.register))
            } label: {
                Text("login.signUpButtonTitle".localized)
                    .font(TravelinDesignSystem.DesignTokens.Typography.bodyBold)
                    .foregroundColor(.black)
            }

            }
    }

    }

#Preview {
    LoginView(loginViewModel: LoginViewModel())
        .environment(\.locale, Locale(identifier: "en"))
}
