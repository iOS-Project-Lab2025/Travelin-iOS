//
//  HomePackageCollectionView.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 10-12-25.
//

import SwiftUI

struct HomePackageCollectionView: View {
    @Binding var packages: [Package]
    let cardWidth: CGFloat

        var body: some View {
            let rows = [GridItem(.fixed(cardWidth))]

            VStack(spacing: 0) {
                Text("Popular package in asia")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: 22, weight: .bold))
                    .padding(.horizontal)
                    .padding(.top, 24)

                ScrollView(.horizontal) {
                    LazyHGrid(rows: rows, spacing: 16) {
                        ForEach(packages) { package in
                            ReusablePackageView(package: package)
                                .frame(width: cardWidth, height: cardWidth)
                        }
                    }
                    .padding()
                }
            }
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
            servicesIncluded: ServicesIncluded(id: UUID(), title: "Bus", subTitle: "Transportation", icon: "bus.fill")
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
            servicesIncluded: ServicesIncluded(id: UUID(), title: "Bus", subTitle: "Transportation", icon: "bus.fill")
        )
    ]), cardWidth: UIScreen.main.bounds.width * 1
    )
}
