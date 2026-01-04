//
//  ProfileEditView.swift
//  Traveling
//
//  Created by Ivan Pereira and Ignacio Alvarado on 23-11-25.
//

import SwiftUI
import TravelinDesignSystem

/// A view that allows the user to edit their profile information.
///
/// This screen provides a form to update personal details such as name, email, and password.
/// It includes navigation back to the previous screen and a save action.
struct ProfileEditView: View {

    // MARK: - Dependencies

    /// The local router for the Profile navigation stack, used to navigate back.
    @Environment(AppRouter.PathRouter<ProfileRoutes>.self) private var profileRouter
    
    /// The main application router, available for global navigation if needed.
    @Environment(\.appRouter) private var appRouter
    
    /// The unique identifier of the user being edited.
    var userId: String
    
    // MARK: - State

    /// The input state for the user's first name.
    @State private var firstName: String = ""
    
    /// The input state for the user's last name.
    @State private var lastName: String = ""
    
    /// The input state for the user's email address.
    @State private var email: String = ""
    
    /// The input state for the user's password.
    @State private var password: String = ""

    // MARK: - Body

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                // Top navigation and title
                header
                
                // Form fields
                bodyContainer()
                
                // Bottom action button
                saveButton
            }
            .padding(.horizontal, 24)
            .padding(.top, 10)
        }
        .navigationBarHidden(true)
    }
    
    // MARK: - Components
    
    /// The header section containing the back button and the screen title.
    private var header: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Back Button
            Button {
                profileRouter.previous()
            }
            label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.black)
            }
            .frame(maxWidth: .infinity, alignment: .leading) // Forces alignment to the left

            // Title and Subtitle
            VStack(alignment: .leading, spacing: 8) {
                Text("profile.editProfile-Title".localized)
                    .font(TravelinDesignSystem.DesignTokens.Typography.heading1)
                    .foregroundColor(.black)
               
                Text("editProfile.descriptionSubTitle".localized)
                    .font(TravelinDesignSystem.DesignTokens.Typography.body)
                    .foregroundColor(TravelinDesignSystem.DesignTokens.Colors.secondaryText)
            }
        }
    }

    /// The main container holding the input fields for the profile form.
    private func bodyContainer() -> some View {
        VStack(spacing: 16) {
           
            // First Name Field
            DSTextField(
                placeHolder: "register.firstNamePlaceHolder".localized,
                type: .givenName,
                label: "register.firstNameTextFieldLabel".localized,
                style: .outlined,
                text: $firstName
            )

            // Last Name Field
            DSTextField(
                placeHolder: "register.lastNamePlaceHolder".localized,
                type: .familyName,
                label: "register.lastNameTextFieldLabel".localized,
                style: .outlined,
                text: $lastName
            )

            // Email Field
            DSTextField(
                placeHolder: "register.emailPlaceHolder".localized,
                type: .email,
                label: "register.emailTextFieldLabel".localized,
                style: .outlined,
                text: $email
            )

            // Password Field
            DSTextField(
                placeHolder: "register.passwordPlaceHolder".localized,
                type: .passwordLetters,
                label: "register.passwordTextFieldLabel".localized,
                style: .outlined,
                text: $password
            )
           
            // Confirm Password Field
            DSTextField(
                placeHolder: "Re enter your password".localized,
                type: .passwordLetters,
                style: .outlined,
                text: $password
            )
        }
    }
    
    /// The bottom section containing the "Save" button.
    private var saveButton: some View {
        VStack {
            Spacer().frame(height: 20)
           
            DSButton(
                title: "editProfile.ButtonTitle".localized,
                variant: .primary
            ) {
                // Action to save changes and return to the previous screen
                profileRouter.previous()
            }
           
            Spacer().frame(height: 20)
        }
    }
}

// MARK: - Preview

#Preview {
    ProfileEditView(userId: "John Due")
        .environment(AppRouter.PathRouter<ProfileRoutes>())
}
