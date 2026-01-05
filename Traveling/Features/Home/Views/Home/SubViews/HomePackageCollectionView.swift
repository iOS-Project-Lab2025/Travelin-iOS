//
//  HomePackageCollectionView.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 10-12-25.
//

import SwiftUI
import TravelinDesignSystem

struct HomePackageCollectionView: View {
    var packages: [Package]
    @Environment(AppRouter.PathRouter<HomeRoutes>.self) private var router
    let screenSize: CGSize
    
    var body: some View {
        VStack(spacing: 0) {
            self.titleView
            ScrollView(.horizontal) {
                LazyHStack(spacing: TravelinDesignSystem.DesignTokens.Spacing.buttonHorizontal) {
                    ForEach(self.packages) { package in
                        ReusablePackageView(package: package, screenSize: self.screenSize)
                            .onTapGesture {
                                self.router.goTo(.poiDetail(id: package.id))
                            }
                    }
                }
            }
        }
        .padding()
    }
    private var titleView: some View {
        Text("Popular package in asia")
            .font(TravelinDesignSystem.DesignTokens.Typography.title1.bold())
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    HomePackageCollectionView(packages: [
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
    ], screenSize: UIScreen.main.bounds.size
    )
}
