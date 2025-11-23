//
//  Onboarding.swift
//  Traveling
//
//  Created by Ivan Pereira on 18-11-25.
//

import SwiftUI

struct OnboardingView: View {
    @Environment(\.appRouter) private var router

    var body: some View {

        VStack {
            Text("Onboarding view")
            Button {
                router.goTo(.authentication(.login))
            } label: {
                Text("Login")
            }

        }

    }
}
