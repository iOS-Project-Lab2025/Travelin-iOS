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
    
    let successType: SuccessType

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
            Text(currentTexts.title1)
                .font(.system(size: 29))
                .fontWeight(.bold)
                .foregroundColor(DesignTokens.Colors.textOnAction)
                .lineSpacing(40 - 32)
                .kerning(-0.165)

            Text(currentTexts.title2)
                .font(.system(size: currentTexts.title2FontSize))
                .fontWeight(.bold)
                .foregroundColor(DesignTokens.Colors.textOnAction)
                .lineSpacing(40 - 32)
                .kerning(-0.165)

            Text(currentTexts.subtitle)
                .font(.system(size: 14))
                .foregroundColor(DesignTokens.Colors.textOnAction)
                .multilineTextAlignment(.center)
        }

    }

    private var button: some View {

        DSButton(
            title: currentTexts.buttonText,
            variant: .ghost
        ) {
            appRouter.goTo(.home)
        }
    }
    
    enum SuccessType {
        case registerSuccess
        case bookingSuccess
    }
    
    struct SuccessTexts {
        var title1: String
        var title2: String
        var subtitle: String
        var buttonText: String
        var title2FontSize: CGFloat
    }
    
    private var currentTexts: SuccessTexts {
        switch successType {
        case .registerSuccess:
            return SuccessTexts(
                title1: "Successfully",
                title2: "created an account",
                subtitle: "After this you can explore any place you want enjoy it!",
                buttonText: "Let's Explore",
                title2FontSize: 25
            )
        case .bookingSuccess:
            return SuccessTexts(
                title1: "Booking",
                title2: "Successfully",
                subtitle: "Get everything ready before your trips date",
                buttonText: "Back to home",
                title2FontSize: 29
            )
        }
    }
    
}

#Preview {
    RegisterSuccessView(successType: .bookingSuccess)
}
