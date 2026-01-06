//
//  ContentView.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 21-10-25.
//

import SwiftUI

struct ContentView: View {

    @Environment(\.appRouter) private var router
    @State private var hideTabBar: Bool = false

    private var shouldShowTabBar: Bool {
        // Hide tab bar if hideTabBar is true
        if hideTabBar {
            return false
        }
        
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
                BookingView(hideTabBar: $hideTabBar)

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
