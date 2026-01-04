//
//  ProfileView.swift
//  Traveling
//
//  Created by Ivan Pereira and Ignacio Alvarado on 21-11-25.
//

import SwiftUI

/// The root view for the Profile feature module.
///
/// This view acts as a container that initializes its own `NavigationStack` managed by a local `profileRouter`.
/// It is responsible for routing between different screens within the Profile flow, such as the main user profile
/// and the edit profile screen.
struct ProfileView: View {
    
    // MARK: - Dependencies
    
    /// The main application router (Singleton), used for top-level navigation (e.g., switching tabs or logging out).
    @Environment(\.appRouter) private var mainRouter
    
    // MARK: - State
    
    /// The local router specifically for the Profile navigation stack.
    /// It maintains the state of the path within this tab.
    @State private var profileRouter = AppRouter.PathRouter<ProfileRoutes>()
    
    /// The unique identifier of the user currently being viewed.
    var userId: String

    // MARK: - Body
    
    var body: some View {
        NavigationStack(path: $profileRouter.path) {
            UserProfileView(userId: userId)
                .navigationDestination(for: ProfileRoutes.self) { route in
                    destinationView(for: route)
                }
        }
        // Inject the router into the environment so child views (like UserProfileView)
        // can access it to push new screens.
        .environment(profileRouter)
    }
    
    // MARK: - Navigation
    
    /// Resolves the specific View to display for a given navigation route.
    ///
    /// - Parameter route: The `ProfileRoutes` enum case indicating the destination.
    /// - Returns: The View corresponding to the requested route.
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

// MARK: - Preview

#Preview {
    ProfileView(userId: "John Doe")
}
