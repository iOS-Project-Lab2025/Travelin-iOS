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

        // 🧪 Temporal: Auth view test
        //SimpleLoginTestView()

        switch router.path {
        case .home:
            HomeView()

        case .onBoarding:
            OnboardingView()

        case .profile:
            ProfileView(userId: "John Doe")

        case .booking:
            BookingView()

        case .authentication(.login):
            LoginView(loginViewModel: LoginViewModel())

        case .authentication(.register):
            RegisterView()
        }

    }
}

#Preview {
    ContentView()
        .environment(AppRouter.Main.shared)
}
