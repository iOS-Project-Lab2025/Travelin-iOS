//
//  ProfileEditView.swift
//  Traveling
//
//  Created by Ivan Pereira on 23-11-25.
//

import SwiftUI

struct ProfileEditView: View {

    @Environment(AppRouter.PathRouter<ProfileRoutes>.self) private var profileRouter
    @Environment(\.appRouter) private var appRouter
    var userId: String

    var body: some View {

        VStack {
            Text("Hello \(userId)")

            Button {
                appRouter.goTo(.home)
            } label: {
                Text("Go to home")
            }

            Button {
                profileRouter.goTo(.userProfile)
            } label: {
                Text("Go to user profile")
            }

        }
    }
}

#Preview {
    ProfileEditView(userId: "John Doe")
        .environment(AppRouter.PathRouter<ProfileRoutes>())
}
