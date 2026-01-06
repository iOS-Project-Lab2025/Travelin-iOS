//
//  DetailPackageView.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 04-01-26.
//

import SwiftUI

struct DetailPackageView: View {
    /// Binding to the selected Package from the source list (HomeViewModel.allPoiPackages).
    /// HomeView resolves the id and passes Binding<Package> into this screen.
    /// Any future edits here can propagate back to the shared state.
    @Binding var package: Package

    var body: some View {
        /// Minimal detail layout: name, description, and favorite status.
        /// Uses plain Text views without design system styling for now.
        /// Consider wrapping in ScrollView later if descriptions grow long.
        VStack {
            Text(package.name)
            Text(package.description)
            Text(package.isFavorite ? "Favorite" : "Not Favorite")
        }
        }
}

#Preview {
    /// Preview uses a constant binding to satisfy @Binding requirements.
    /// Sample Package data mirrors what the app would pass at runtime.
    /// Useful to verify basic layout and conditional favorite label.
    DetailPackageView(package: .constant(Package(
        id: "01",
        imagesCollection: ["package1"],
        name: "Koh Rong Samloem",
        rating: 4,
        numberReviews: 90,
        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
        isFavorite: true,
        price: 600,
        servicesIncluded: [ServicesIncluded(id: UUID(), title: "2 day 1 night", subTitle: "Duration", icon: "clock.fill")]
    )))
}

