//
//  OnboardingView.swift
//  Traveling
//
//  Created by NVSH on 19-11-25.
//

import SwiftUI
import TravelinDesignSystem

/*
    @Environment(\.appRouter) private var router

    var body: some View {

        VStack {
            Text("Onboarding view")
            Button {
                router.completeOnboarding()
            } label: {
                Text("Complete Onboarding")
            }

        }

    }
*/

struct OnboardingView: View {
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false

    @State private var currentStep = 0
    
    var body: some View {
        ZStack {
            OnboardingBackgroundView(
                currentStep: $currentStep,
                steps: onboardingSteps
            )

            VStack {
                Spacer()

                OnboardingHeaderView()
                
                OnboardingCardView(
                    step: onboardingSteps[currentStep], isLastStep: currentStep == onboardingSteps.count - 1, action: handleNextButton
                )

                OnboardingIndicatorsView(totalSteps: onboardingSteps.count, currentStep: currentStep)
            }
        }
    }
    
    func handleNextButton() {
        if currentStep < onboardingSteps.count - 1 {
            withAnimation {
                currentStep += 1
            }
        } else {
            withAnimation {
                hasCompletedOnboarding = true
            }
        }
    }
}

private struct OnboardingBackgroundView: View {
    @Binding var currentStep: Int
    let steps: [OnboardingStep]
    
    var body: some View {
        TabView(selection: $currentStep){
            ForEach(0..<steps.count, id: \.self) { index in
                Image(steps[index].image)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .tag(index)
            }
        }
    }
}

private struct OnboardingHeaderView: View {
    var body: some View {
        HStack {
            Image("AppLogoGray")
                .resizable() // Added resizable to ensure frame works
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
            Spacer()
        }
        .padding(10)
    }
}

private struct OnboardingCardView: View {
    let step: OnboardingStep
    let isLastStep: Bool
    let action: () -> Void
    
    // Computed property specific to this view
    private var buttonTitle: String {
        isLastStep ? "Let's Go" : "Next"
    }
    
    var body: some View {
        VStack(spacing: 24) {
            
            VStack(alignment: .leading, spacing: 12) {
                // Title
                Text(step.title)
                    .font(TravelinDesignSystem.DesignTokens.Typography.heading1)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.black)
                // Description
                Text(step.description)
                    .font(TravelinDesignSystem.DesignTokens.Typography.title2)
                    .foregroundColor(TravelinDesignSystem.DesignTokens.Colors.secondaryText)
            }
            .frame(maxWidth: .infinity, alignment: .leading) // Ensure left alignment
            
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

private struct OnboardingIndicatorsView: View {
    let totalSteps: Int
    let currentStep: Int
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<totalSteps, id: \.self) { index in
                Rectangle()
                    .frame(width: 18, height: 6)
                    .foregroundColor(currentStep == index ? .white : .gray.opacity(0.8))
                    .cornerRadius(3) // Adjusted corner radius relative to height
                    .animation(.spring(), value: currentStep)
            }
        
        }
        .padding(.bottom, 10) // Extra padding for safe area
    }
}

#Preview {
    OnboardingView()
}
