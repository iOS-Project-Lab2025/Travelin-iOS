//
//  UserProfileView.swift
//  Traveling
//
//  Created by Ivan Pereira and Ignacio Alvarado on 23-11-25.
//

import SwiftUI
import TravelinDesignSystem

/// A view that displays the user's profile information and account settings.
///
/// This view serves as the main dashboard for the user, showing their avatar, name,
/// and providing a menu of actions such as editing the profile, changing settings, or logging out.
struct UserProfileView: View {

    // MARK: - Dependencies

    /// The router responsible for handling navigation within the Profile flow.
    /// It is injected via the environment to allow pushing new views onto the stack.
    @Environment(AppRouter.PathRouter<ProfileRoutes>.self) private var profileRouter
    
    // MARK: - Properties

    /// The unique identifier of the user currently logged in.
    var userId: String

    // MARK: - Body

    var body: some View {
        VStack {
            // Top section with Avatar and Name
            headerContainer()

            Divider()
                .frame(height: 20)
                .padding(.horizontal, 12)

            // Menu options and buttons
            bodyContainer()
            
            // Pushes content to the top
            Spacer()
        }
        .padding()
    }

    // MARK: - Components

    /// Renders the top header section containing the user's avatar and personal details.
    private func headerContainer() -> some View {
        HStack(spacing: 16) {
            // Avatar Image
            Image("profile_placeholder")
                .resizable()
                .scaledToFill()
                .frame(width: 70, height: 70)
                .clipShape(Circle())

            // Text Info (Name and Location/Description)
            VStack(alignment: .leading, spacing: 4) {
                Text("John Due") // Note: Typically this would come from a ViewModel
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.black)

                Text("Mars, Solar System")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            Spacer()
        }
    }

    /// Renders the list of action buttons and account settings.
    private func bodyContainer() -> some View {
        VStack(spacing: 16) {
            
            // Section Title
            Text("profile.accountSettings-Title".localized)
                .font(.title2)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // Edit Profile Button
            DSButton(
                title: "profile.editProfileButton-Title".localized,
                icon: Image(systemName: "person.circle"),
                trailingIcon: Image(systemName: "chevron.right"),
                variant: .transparent,
                size: .menu,
                fixedWidth: 323
            ) {
                profileRouter.goTo(.editUserProfile)
            }

            // Color Mode Button
            DSButton(
                title: "profile.colorModeButton-Title".localized,
                icon: Image(systemName: "moon"),
                trailingIcon: Image(systemName: "chevron.right"),
                variant: .transparent,
                size: .menu,
                fixedWidth: 323
            ) {
                // Action for color mode toggle
            }

            // Logout Button
            DSButton(
                title: "profile.logoutButton-Title".localized,
                variant: .outline,
                size: .large,
                fixedWidth: 295
            ) {
                // Action for logout
            }

            // Delete Account Button
            DSButton(
                title: "profile.deleteAccountButton-Title".localized,
                variant: .secondary,
                size: .large,
                fixedWidth: 295
            ) {
                // Action for account deletion
            }

            // App Version
            Text("Version 1.0.0")
                .fontWeight(.light)
                .font(.caption)
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
        }
    }
}

// MARK: - Preview

#Preview {
    UserProfileView(userId: "John Doe")
        .environment(AppRouter.PathRouter<ProfileRoutes>())
}
