import SwiftUI
import TravelinDesignSystem

struct UserProfileView: View {

    @Environment(AppRouter.PathRouter<ProfileRoutes>.self) private var profileRouter
    var userId: String

    var body: some View {
        
        VStack {
            headerContainer()

            Divider()
                .frame(height: 20)
                .padding(.horizontal, 12)
            
            bodyContainer()
            Spacer()
        }
        .padding()
    }
    
    private func headerContainer() -> some View {
        HStack(spacing: 16) {
            // Avatar
            Image("profile_placeholder")
                .resizable()
                .scaledToFill()
                .frame(width: 70, height: 70)
                .clipShape(Circle())
            
            // Text Info
            VStack(alignment: .leading, spacing: 4) {
                Text("Username")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
                Text("Description")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
    }

    private func bodyContainer() -> some View {
        VStack(spacing: 16) {
            Text("profile.accountSettings-Title".localized)
                .font(.title2)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
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
            
            DSButton(
                title: "profile.colorModeButton-Title".localized,
                icon: Image(systemName: "moon"),
                trailingIcon: Image(systemName: "chevron.right"),
                variant: .transparent,
                size: .menu,
                fixedWidth: 323
            ) { }
            
            DSButton(
                title: "profile.logoutButton-Title".localized,
                variant: .outline,
                size: .large,
                fixedWidth: 295
            ) { }
            
            DSButton(
                title: "profile.deleteAccountButton-Title".localized,
                variant: .secondary,
                size: .large,
                fixedWidth: 295
            ) { }

            Text("Version 1.0.0")
                .fontWeight(.light)
                .font(.caption)
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    UserProfileView(userId: "John Doe")
        .environment(AppRouter.PathRouter<ProfileRoutes>())
}
