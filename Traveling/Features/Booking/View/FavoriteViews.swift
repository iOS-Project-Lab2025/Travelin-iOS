//
//  FavoriteViews.swift
//  Traveling
//
//  Created by Ivan Pereira on 29-12-25.
//

import SwiftUI

struct FavoritesView: View {

    @Environment(\.appRouter) private var appRouter

    var body: some View {
        VStack {

            Text("Favourite views")

            Button {
                appRouter.goTo(.home)
            } label: {
                Text("Go home")
            }
        }

    }
}

#Preview {
    FavoritesView()
}
