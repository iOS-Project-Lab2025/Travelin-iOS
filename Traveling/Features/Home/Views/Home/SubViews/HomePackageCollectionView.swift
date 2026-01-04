//
//  HomePackageCollectionView.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 10-12-25.
//

import SwiftUI

struct HomePackageCollectionView: View {
    @Binding var packages: [Package]
    @Binding var router: AppRouter.PathRouter<HomeRoutes>
    
    let screenSize: CGSize

        var body: some View {
            
            VStack(spacing: 0) {
                Text("Popular package in asia")

                    .font(.system(size: 20, weight: .bold))

                    .frame(maxWidth: .infinity, alignment: .leading)

                ScrollView(.horizontal) {
                    LazyHStack(spacing: 20) {
                        ForEach(packages) { package in
                            ReusablePackageView(package: package, size: screenSize)
                                .onTapGesture {
                                    router.goTo(.poiDetail(id: package.id))
                                }
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
            id: "01",
            imagesCollection: ["package1"],
            name: "Koh Rong Samloem",
            rating: 3,
            numberReviews: 50,
            description: "Lorem ipsum dolor sit amet...",
            isFavorite: true,
            price: 600,
            servicesIncluded: [ServicesIncluded(id: UUID(), title: "2 day 1 night", subTitle: "Duration", icon: "clock.fill")]
        ), Package(
            id: "02",
            imagesCollection: ["package1"],
            name: "Koh Rong Samloem",
            rating: 4,
            numberReviews: 90,
            description: "Lorem ipsum dolor sit amet...",
            isFavorite: true,
            price: 600,
            servicesIncluded: [ServicesIncluded(id: UUID(), title: "2 day 1 night", subTitle: "Duration", icon: "clock.fill")]
        )
    ]), router: .constant(AppRouter.PathRouter<HomeRoutes>()), screenSize: UIScreen.main.bounds.size
    )
}
