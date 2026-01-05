//
//  HomeCountriesCollectionView.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 10-12-25.
//

import SwiftUI
import TravelinDesignSystem

struct HomeCountriesCollectionView: View {
    /// Immutable data source for the country carousel.
    /// Provided by the parent (HomeViewModel.countries).
    /// This view only renders; it does not mutate countries.
    let countries: [Country]

    /// Used to compute card size and title padding responsively.
    /// Passed from GeometryReader (geo.size) in HomeView.
    /// Helps keep consistent proportions across devices.
    let screenSize: CGSize
    
    var body: some View {
        /// Section layout: title + horizontal scrollable list.
        /// LazyHStack improves performance for long carousels.
        /// Spacing is driven by design system tokens.
        VStack(spacing: 0) {
            self.titleView
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: TravelinDesignSystem.DesignTokens.Spacing.medium) {
                    /// Iterates over countries as value items (no bindings).
                    /// Each cell is a ReusableCountriesView card.
                    /// Card sizing is derived from screen width for consistency.
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
        /// Section header text shown above the carousel.
        /// Two-line limit avoids overly tall headers on small screens.
        /// Extra trailing padding keeps the title from spanning too wide.
        Text("Expanding your trip around the world")
            .lineLimit(2)
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(TravelinDesignSystem.DesignTokens.Typography.heading2)
            .padding(.horizontal)
            .padding(.trailing, self.screenSize.width * 0.2)
    }
}

#Preview {
    /// Preview provides sample countries and a screen-sized container.
    /// Useful to validate spacing, title wrapping, and card proportions.
    /// Uses asset keys like "country1" to render the background image.
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

