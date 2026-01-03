//
//  ProfileView.swift
//  Traveling
//
//  Created by Ivan Pereira on 21-11-25.
//

import SwiftUI

struct ProfileView: View {
    @Environment(\.appRouter) private var router
    @State private var profileRouter = AppRouter.PathRouter<ProfileRoutes>()
    var userId: String

    var body: some View {
        NavigationStack(path: $profileRouter.path) {
            UserProfileView(userId: userId)
                .navigationDestination(for: ProfileRoutes.self) { route in
                    destinationView(for: route)
                }

        }
        .environment(profileRouter)
    }
        @ViewBuilder
        private func destinationView(for route: ProfileRoutes) -> some View {
            switch route {
            case .editUserProfile:
            ProfileEditView(userId: userId)

            case .userProfile:
            UserProfileView(userId: userId)
            }
    }

}

#Preview {
    ProfileView(userId: "John Doe")
}
