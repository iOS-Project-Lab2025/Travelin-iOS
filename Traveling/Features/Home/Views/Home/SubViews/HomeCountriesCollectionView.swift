//
//  HomeCountriesCollectionView.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 10-12-25.
//

import SwiftUI
import TravelinDesignSystem

struct HomeCountriesCollectionView: View {
    var countries: [Country]
    let screenSize: CGSize
    
    var body: some View {
        VStack(spacing: 0) {
            self.titleView
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: TravelinDesignSystem.DesignTokens.Spacing.medium) {
                    ForEach(self.countries) { country in
                        ReusableCountriesView(
                            country: country,
                            screenSize: CGSize(width: self.screenSize.width * 0.5, height: self.screenSize.width * 0.55)
                        )
                    }
                }
                .padding()
            }
        }
    }
    private var titleView: some View {
        Text("Expanding your trip around the world")
            .lineLimit(2)
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(TravelinDesignSystem.DesignTokens.Typography.heading2)
            .padding(.horizontal)
            .padding(.trailing, self.screenSize.width * 0.2)
    }
}

#Preview {
    HomeCountriesCollectionView(
        countries:
            [
                Country(
                    id: UUID(),
                    name: "Cambodia",
                    imageURL: "country1"
                ),
                Country(
                    id: UUID(),
                    name: "Cambodia",
                    imageURL: "country1"
                )
            ]
        , screenSize: UIScreen.main.bounds.size
    )
}
