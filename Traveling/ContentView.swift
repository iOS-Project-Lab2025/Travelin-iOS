//
//  ContentView.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 21-10-25.
//

import SwiftUI

struct ContentView: View {

    @Environment(\.appRouter) private var router

    private var shouldShowTabBar: Bool {
        switch router.path {
        case .home, .wishlist, .profile, .booking:
            return true

        default:
            return false
        }
    }

    var body: some View {
        ZStack {
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
                RegisterView(registerViewModel: RegisterViewModel())

            case .wishlist:
                WishListView()
            }

            if shouldShowTabBar {
                VStack {
                    Spacer()
                    TapBar()
                }
            }
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
