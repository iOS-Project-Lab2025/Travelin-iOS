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
        case .home:
            HomeView()

        case .onBoarding:
            OnboardingView()

        case .profile:
            ProfileView(userId: "John Doe")

        case .booking:
            BookingView()
            
        case .wishlist:
            WishListView()
        }

        case .authentication(.login):
            LoginView(
                loginViewModel: LoginViewModel(
                    authService: Services.auth,
                    userService: Services.user,
                    tokenManager: Services.tokenManager
                )
            )

        case .authentication(.register):
            RegisterView(registerViewModel: RegisterViewModel())
    }
}

#Preview {
    ContentView()
        .environment(AppRouter.Main.shared)
}
