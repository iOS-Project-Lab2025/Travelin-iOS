//
//  ProfileTestView.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 04-01-26.
//

import SwiftUI

struct DetailPackageView: View {
    let package: Package
    var body: some View {
        Text(package.name)
        Text(package.description)
        Text(package.isFavorite ? "Favorite" : "Not Favorite")
    }
}

#Preview {
    DetailPackageView(package: Package(
        id: "01",
        imagesCollection: ["package1"],
        name: "Koh Rong Samloem",
        rating: 4,
        numberReviews: 90,
        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
        isFavorite: true,
        price: 600,
        servicesIncluded: [ServicesIncluded(id: UUID(), title: "2 day 1 night", subTitle: "Duration", icon: "clock.fill")]
    ))
}
