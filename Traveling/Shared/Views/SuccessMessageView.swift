//
//  SuccessMessageView.swift
//  Traveling
//
//  Created by Ivan Pereira on 23-11-25.
//

import SwiftUI
import TravelinDesignSystem

/// A generic view displayed to indicate a successful action, such as registration or booking.
///
/// `SuccessMessageView` presents a customizable success message based on the provided `SuccessType`.
/// It displays a gradient background, the app logo, title, subtitle, and a button to navigate
/// (usually to the home screen).
///
/// Use the `successType` property to configure the content for specific scenarios.
///
/// - SeeAlso: `SuccessType`
struct SuccessMessageView: View {
    @Environment(\.appRouter) private var appRouter

    let successType: SuccessType

    var body: some View {
        ZStack {
            background
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

    private var background: some View {
        LinearGradient(
            colors: [
                DesignTokens.Colors.gradientColor1,  // #0FA3E2
                DesignTokens.Colors.gradientColor2     // #49C9FF
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
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

    /// Defines the type of success message to display.
    enum SuccessType {
        /// Indicates successful user registration.
        case registerSuccess
        /// Indicates a successful booking.
        case bookingSuccess
    }

    /// A structure holding the textual content and configuration for the success view.
    private struct SuccessTexts {
        /// The first line of the main title.
        var title1: String
        /// The second line of the main title.
        var title2: String
        /// The subtitle describing the success state.
        var subtitle: String
        /// The text to display on the action button.
        var buttonText: String
        /// The font size for the second line of the title.
        var title2FontSize: CGFloat
    }

    private var currentTexts: SuccessTexts {
        switch successType {
        case .registerSuccess:
            return SuccessTexts(
                title1: "RegisterSuccessView.title1".localized,
                title2: "RegisterSuccessView.title2".localized,
                subtitle: "RegisterSuccessView.subtitle".localized,
                buttonText: "RegisterSuccessView.button".localized,
                title2FontSize: 25
            )

        case .bookingSuccess:
            return SuccessTexts(
                title1: "BookingSuccessView.title1".localized,
                title2: "BookingSuccessView.title2".localized,
                subtitle: "BookingSuccessView.subtitle".localized,
                buttonText: "BookingSuccessView.button".localized,
                title2FontSize: 29
            )
        }
    }

}

#Preview {
    SuccessMessageView(successType: .bookingSuccess)
}
