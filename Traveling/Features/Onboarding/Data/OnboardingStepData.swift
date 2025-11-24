//
//  OnboardingStep.swift
//  Traveling
//
//  Created by NVSH on 19-11-25.
//

import Foundation

struct OnboardingStep: Identifiable {
    let id = UUID()
    let image: String
    let title: String
    let description: String
}

let onboardingSteps = [
    OnboardingStep(
        image: "OnboardingImage1",
        title: "Get ready for the next trip",
        description: "Find thousans of tourist destinations ready for you to visit"
    ),
    OnboardingStep(
        image: "OnboardingImage2",
        title: "Visit tourist attractions",
        description: "Find thousans of tourist destinations ready for you to visit"
    ),
    OnboardingStep(
        image: "OnboardingImage3",
        title: "Lets explore the world",
        description: "Find thousans of tourist destinations ready for you to visit"
    )
]
