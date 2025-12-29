//
//  OnboardingView.swift
//  Traveling
//
//  Created by NVSH on 19-11-25.
//

import SwiftUI
import TravelinDesignSystem

// MARK: - Main View

/// The main entry point for the Onboarding flow.
///
/// This view orchestrates the interaction between the background image carousel,
/// the floating content card, and the navigation logic. It relies on the
/// `appRouter` to transition the user to the main app once onboarding is complete.
struct OnboardingView: View {

    // MARK: - Dependencies

    /// Access to the global navigation router to handle the "Finish" action.
    @Environment(\.appRouter) private var router

    // MARK: - State

    /// Tracks the currently visible step index in the onboarding flow.
    @State private var currentStep = 0

    // MARK: - Body

    var body: some View {
        ZStack {
            // 1. Background Layer: Full screen image carousel
            OnboardingBackgroundView(
                currentStep: $currentStep,
                steps: onboardingSteps
            )

            // 2. Foreground Layer: Header, Card, and Indicators
            VStack {
                Spacer()

                // Logo Header
                OnboardingHeaderView()

                // Interactive Card (Text + Button)
                OnboardingCardView(
                    step: onboardingSteps[currentStep],
                    isLastStep: currentStep == onboardingSteps.count - 1,
                    action: handleNextButton
                )

                // Pagination Dots
                OnboardingIndicatorsView(
                    totalSteps: onboardingSteps.count,
                    currentStep: currentStep
                )
            }
        }
    }

    // MARK: - Actions

    /// Handles the primary button tap action.
    ///
    /// - Logic:
    ///   1. If the current step is **not** the last one, it increments `currentStep` with animation.
    ///   2. If it **is** the last step, it calls `router.completeOnboarding()` to navigate to the Home screen.
    func handleNextButton() {
        if currentStep < onboardingSteps.count - 1 {
            withAnimation {
                currentStep += 1
            }
        } else {
            withAnimation {
                router.completeOnboarding()
            }
        }
    }
}

// MARK: - Subviews

/// Displays the full-screen background image carousel.
///
/// Uses a `TabView` with `PageTabViewStyle` to support swiping between images.
/// It includes specific layout logic (`UIScreen.main.bounds` + `.clipped()`) to ensure
/// a smooth, full-screen experience without visual glitches during transitions.
private struct OnboardingBackgroundView: View {

    /// Binding to the parent's state index.
    @Binding var currentStep: Int

    /// The data source containing the image names for each step.
    let steps: [OnboardingStep]

    var body: some View {
        TabView(selection: $currentStep) {
            ForEach(0..<steps.count, id: \.self) { index in
                Image(steps[index].image)
                    .resizable()
                    .scaledToFill()

                    // 1. PHYSICAL SIZE FORCE:
                    // We use `UIScreen.main.bounds` instead of `GeometryReader`.
                    // This guarantees the image frame exactly matches the device's physical hardware,
                    // effectively covering the top notch/dynamic island without leaving white gaps.
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)

                    // 2. CLIPPING:
                    // Since `.scaledToFill` makes the image larger than the frame, we must
                    // explicitly clip the overflow. This prevents the "jumping/flickering" bug
                    // that occurs in SwiftUI TabViews during swiping transitions.
                    .clipped()

                    // 3. SAFE AREA IGNORE:
                    // Ensures the content extends behind the status bar and home indicator.
                    .ignoresSafeArea()

                    .tag(index)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        // Important: The container itself must also ignore safe areas to be truly full-screen.
        .ignoresSafeArea()
    }
}

/// Displays the application branding/logo at the top of the content stack.
private struct OnboardingHeaderView: View {
    var body: some View {
        HStack {
            Image("AppLogoGray")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
            Spacer()
        }
        .padding(10)
    }
}

/// A reusable component for the Onboarding Step Title.
/// Uses the Design System's `heading1` typography.
public struct OnboardingCardViewTitle: View {
    let stepTitle: String

    public var body: some View {
        Text(stepTitle)
            .font(TravelinDesignSystem.DesignTokens.Typography.heading1)
            .multilineTextAlignment(.leading)
            .foregroundColor(.black)
    }
}

/// A reusable component for the Onboarding Step Description.
/// Uses the Design System's `title2` and `secondaryText` color.
public struct OnboardingCardViewDescription: View {
    let stepDescription: String

    public var body: some View {
        Text(stepDescription)
            .font(TravelinDesignSystem.DesignTokens.Typography.title2)
            .foregroundColor(TravelinDesignSystem.DesignTokens.Colors.secondaryText)
    }
}

/// The main white card container that holds the text content and the primary action button.
private struct OnboardingCardView: View {

    /// The data for the current step (title and description).
    let step: OnboardingStep

    /// Indicates if the current view is the final step of the onboarding.
    let isLastStep: Bool

    /// The closure to execute when the button is tapped.
    let action: () -> Void

    /// Computes the button text based on the current state.
    /// Returns "Let's Go" for the final step, otherwise "Next".
    private var buttonTitle: String {
        isLastStep ? "Let's Go" : "Next"
    }

    var body: some View {
        VStack(spacing: 24) {

            // Text Content Block
            VStack(alignment: .leading, spacing: 12) {
                OnboardingCardViewTitle(stepTitle: step.title)
                OnboardingCardViewDescription(stepDescription: step.description)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Spacer()

            // Design System Button
            TravelinDesignSystem.DSButton(
                title: buttonTitle,
                variant: .primary, // Using primary for both states based on your design system
                size: .large,
                action: action
            )
        }
        .frame(height: 260)
        // Design Tokens for Spacing
        .padding(TravelinDesignSystem.DesignTokens.Spacing.mediumLarge)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: 10)
        )
        .padding(.horizontal, TravelinDesignSystem.DesignTokens.Spacing.mediumSmall)
        .padding(.bottom, TravelinDesignSystem.DesignTokens.Spacing.mediumLarge)
    }
}

/// Displays the custom page indicators (dots/rectangles) at the bottom of the screen.
private struct OnboardingIndicatorsView: View {

    /// The total number of pages in the carousel.
    let totalSteps: Int

    /// The index of the currently active page.
    let currentStep: Int

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<totalSteps, id: \.self) { index in
                Rectangle()
                    .frame(width: 18, height: 6)
                    // Highlighting logic: White for active, Gray for inactive
                    .foregroundColor(currentStep == index ? .white : .gray.opacity(0.8))
                    .cornerRadius(3)
                    .animation(.spring(), value: currentStep)
            }

        }
        .padding(.bottom, 10) // Extra padding for safe area
    }
}

// MARK: - Preview

#Preview {
    OnboardingView()
}
