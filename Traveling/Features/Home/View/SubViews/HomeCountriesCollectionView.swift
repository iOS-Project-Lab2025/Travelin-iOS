//
//  HomeCountriesCollectionView.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 10-12-25.
//

import SwiftUI

struct HomeCountriesCollectionView: View {
    @Binding var countries: [Country]
    let cardWidth: CGFloat

        

        var body: some View {
            // Define las filas del grid
            let rows = [
                GridItem(.fixed(cardWidth)
                        )
            ]
            VStack(spacing: 0) {
                Text("Expanding your trip around the world")
                    .lineLimit(2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: 24, weight: .bold))
                    .padding(.horizontal)
                    .padding(.trailing, cardWidth * 0.8)
                    .padding(.top, 24)
                ScrollView(.horizontal, showsIndicators: true) {
                    LazyHGrid(rows: rows, spacing: 16) {
                        ForEach(countries) { country in
                            ReusableCountriesView(country: country)
                            .frame(width: cardWidth)
                        }
                    }
                    .padding()
                }
            }
        }
}

#Preview {
    HomeCountriesCollectionView(
        countries: .constant(
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
        ), cardWidth: UIScreen.main.bounds.width * 0.45
    )
}

