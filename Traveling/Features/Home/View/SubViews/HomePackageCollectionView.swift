//
//  HomePackageCollectionView.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 10-12-25.
//

import SwiftUI

struct HomePackageCollectionView: View {
    @Binding var packages: [Package]
    let screenSize: CGSize

        var body: some View {
            let rows = [GridItem(.fixed(screenSize.width * 1.1))]

            VStack(spacing: 0) {
                Text("Popular package in asia")

                    .font(.system(size: 20, weight: .bold))

                    .frame(maxWidth: .infinity, alignment: .leading)

                ScrollView(.horizontal) {
                    LazyHGrid(rows: rows, spacing: 20) {
                        ForEach(packages) { package in
                            ReusablePackageView(package: package, size: CGSize(width: screenSize.width * 0.6, height: screenSize.width * 0.7))

                        }
                    }
                }
            }
            .padding()
        }
}

#Preview {
    HomePackageCollectionView(packages: .constant([
        Package(
            id: UUID(),
            imageURL: "package1",
            imagesCollection: [],
            name: "Koh Rong Samloem",
            rating: 3,
            numberReviews: 50,
            description: "Lorem ipsum dolor sit amet...",
            isFavorite: true,
            price: 600,
            servicesIncluded: [ServicesIncluded(id: UUID(), title: "2 day 1 night", subTitle: "Duration", icon: "clock.fill")]
        ), Package(
            id: UUID(),
            imageURL: "package1",
            imagesCollection: [],
            name: "Koh Rong Samloem",
            rating: 4,
            numberReviews: 90,
            description: "Lorem ipsum dolor sit amet...",
            isFavorite: true,
            price: 600,
            servicesIncluded: [ServicesIncluded(id: UUID(), title: "2 day 1 night", subTitle: "Duration", icon: "clock.fill")]
        )
    ]), screenSize: UIScreen.main.bounds.size
    )
}
