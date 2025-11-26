//
//  OnboardingStep.swift
//  Traveling
//
//  Created by NVSH on 19-11-25.
//

import Foundation

// MARK: - Data Model

/// A data model representing a single page within the Onboarding carousel.
///
/// This struct conforms to `Identifiable` so it can be easily iterated over
/// in SwiftUI `ForEach` loops or `List` views.
struct OnboardingStep: Identifiable {
    
    /// A unique identifier for the step, automatically generated.
    /// Required for the `Identifiable` protocol to distinguish between steps.
    let id = UUID()
    
    /// The name of the image asset to display as the background or main visual.
    /// - Note: Ensure this string matches the name of an Image Set in `Assets.xcassets`.
    let image: String
    
    /// The main headline text for this step.
    let title: String
    
    /// The supporting body text providing more details about the feature.
    let description: String
}

// MARK: - Mock Data

/// A static collection of onboarding steps used to populate the `OnboardingView`.
///
/// This array acts as the data source for the onboarding carousel.
/// To add or remove pages from the onboarding flow, simply modify this array.
let onboardingSteps = [
    OnboardingStep(
        image: "OnboardingImage1",
        title: "Get ready for the next trip",
        description: "Find thousands of tourist destinations ready for you to visit"
    ),
    OnboardingStep(
        image: "OnboardingImage2",
        title: "Visit tourist attractions",
        description: "Find thousands of tourist destinations ready for you to visit"
    ),
    OnboardingStep(
        image: "OnboardingImage3",
        title: "Let's explore the world",
        description: "Find thousands of tourist destinations ready for you to visit"
    )
]
