//
//  HomeCountriesCollectionView.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 10-12-25.
//

import SwiftUI

struct HomeCountriesCollectionView: View {
    @Binding var countries: [Country]
    let items = Array(1...10)

        // Define las filas del grid
        let rows = [
            GridItem(.fixed(UIScreen.main.bounds.width * 0.45)
                    ),
        ]

        var body: some View {
            VStack(spacing: 0) {
                Text("Expanding your trip around the world")
                    .lineLimit(2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .bold()
                    .font(.system(size: 24))
                    .padding(.leading)
                    .padding(.trailing, UIScreen.main.bounds.width * 0.3)
                    .padding(.top, 24)
                ScrollView(.horizontal, showsIndicators: true) {
                    LazyHGrid(rows: rows, spacing: 16) {
                        ForEach(countries) { country in
                            ReusableCountriesView(country: country)
                            .frame(width: UIScreen.main.bounds.width * 0.45)
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
        )
    )
}

