//
//  RegisterSuccessView.swift
//  Traveling
//
//  Created by Ivan Pereira on 23-11-25.
//

import SwiftUI
import TravelinDesignSystem

/// A view displayed upon successful registration.
///
/// `RegisterSuccessView` presents a success message to the user and provides a button to navigate
/// to the home screen, effectively ending the on-boarding or registration flow.
///
/// It uses `AppRouter` to navigate to the main application flows.
struct RegisterSuccessView: View {
    @Environment(\.appRouter) private var appRouter

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.06, green: 0.64, blue: 0.89),  // #0FA3E2
                    Color(red: 0.29, green: 0.79, blue: 1.0)     // #49C9FF
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack {
                Spacer()
                logo
                texts
                Spacer()
                button

            }
            .padding(37)
        }
        .navigationBarBackButtonHidden(true)

    }

    private var logo: some View {
        VStack {
            Image("AppLogoWhite")
                .padding(.bottom, 13)
        }
    }

    private var texts: some View {
        VStack {
            Text("Successfully")
                .font(.system(size: 29))
                .fontWeight(.bold)
                .foregroundColor(.white)
                .lineSpacing(40 - 32)
                .kerning(-0.165)

            Text("created an account")
                .font(.system(size: 25))
                .fontWeight(.bold)
                .foregroundColor(.white)
                .lineSpacing(40 - 32)
                .kerning(-0.165)

            Text("After this you can explore any place you want enjoy it!")
                .font(.system(size: 14))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
        }

    }

    private var button: some View {

        DSButton(
            title: "Let's Explore",
            variant: .ghost
        ) {
            appRouter.goTo(.home)
        }
    }
}

#Preview {
    RegisterSuccessView()
}
