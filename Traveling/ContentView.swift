//
//  ContentView.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 21-10-25.
//

import SwiftUI

struct ContentView: View {

    @Environment(\.appRouter) private var router

    var body: some View {

        switch router.activeRoute {
        case .home:
            HomeView()

        case .onBoarding:
            OnboardingView()

        case .profile:
            ProfileView()

        case .booking:
            BookingView()

        case .authentication(.login):
            LoginView()

        case .authentication(.register):
            RegisterView()
        }
    }
}

#Preview {
    ContentView()
        .environment(AppRouter.shared)
}
