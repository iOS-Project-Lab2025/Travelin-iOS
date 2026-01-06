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

    @ViewBuilder
    private var mainContent: some View {
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
    }

    var body: some View {
        VStack(spacing: 0) {
            // Esto asegura que el contenido ocupa toda la altura disponible
            mainContent
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)

            if shouldShowTabBar {
                TapBar()
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom) // mantiene tu intención original
    }
}



