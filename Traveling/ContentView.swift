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

        switch router.path {
        case .initial:
            InitialView()

        case .home:
            HomeView()

        case .onBoarding:
            OnboardingView()

        case .profile:
            ProfileView(userId: "John Doe")

        case .booking:
            BookingView()

        case .authentication(.login):
            LoginView(
                loginViewModel: LoginViewModel(
                    authService: Services.auth,
                    userService: Services.user,
                    tokenManager: Services.tokenManager
                )
            )

        case .authentication(.register):
            RegisterView()
        }

    }
}

#Preview {
    ContentView()
        .environment(AppRouter.Main.shared)
}

struct InitialView: View {
    @Environment(\.appRouter) private var router

    private let options: [(title: String, route: AppRoutes)] = [
        ("Go to Home", .home),
        ("Go to Onboarding", .onBoarding),
        ("Go to Login", .authentication(.login)),
        ("Go to Register", .authentication(.register)),
        ("Go to Profile", .profile),
        ("Go to Booking", .booking)
    ]

    var body: some View {
        VStack {
            Text("Home")

            List(options, id: \.title) { option in
                Button(option.title) {
                    router.goTo(option.route)
                }
            }
        }
    }
}
