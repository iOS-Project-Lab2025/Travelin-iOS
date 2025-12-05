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
            Text("login.title")
                .font(TravelinDesignSystem.DesignTokens.Typography.heading2)

            Text("login.subtitle")
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
            .padding(.bottom, 14)

            DSTextField(
                placeHolder: "login.passwordPlaceHolder".localized,
                 type: .passwordLetters,
                label: "login.passwordTextFieldLabel".localized,
                 style: .outlined,
                 text: $loginViewModel.password
             )
            .padding(.bottom, 10)

            DSButton(title: "login.loginButtonTitle".localized, variant: .primary) {
                self.loginViewModel.login()
            }
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
}
