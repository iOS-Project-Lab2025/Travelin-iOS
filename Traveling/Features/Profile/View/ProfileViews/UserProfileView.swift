//
//  UserProfileView.swift
//  Traveling
//
//  Created by Ivan Pereira on 23-11-25.
//

import SwiftUI

struct UserProfileView: View {

    @Environment(AppRouter.PathRouter<ProfileRoutes>.self) private var profileRouter
    var userId: String

    var body: some View {
        VStack {
            Text("User profile: \(userId)")
            Button {
                profileRouter.goTo(.editUserProfile)
            } label: {
                Text("Edit profile")
            }

        }
    }
}

#Preview {
    UserProfileView(userId: "John Doe")
}
