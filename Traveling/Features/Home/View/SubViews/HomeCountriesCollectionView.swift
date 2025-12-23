//
//  HomeCountriesCollectionView.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 10-12-25.
//

import SwiftUI

struct HomeCountriesCollectionView: View {
    @Binding var countries: [Country]
    
    let screenSize: CGSize
    
    var body: some View {
        let rows = [GridItem(.fixed(screenSize.width * 0.55))]
        
        VStack(spacing: 0) {
            Text("Expanding your trip around the world")
                .lineLimit(2)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.system(size: 22, weight: .bold))
                .padding(.horizontal)
                .padding(.trailing, screenSize.width * 0.2)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: rows, spacing: 16) {
                    ForEach(countries) { country in
                        ReusableCountriesView(
                            country: country,
                            size: CGSize(width: screenSize.width * 0.5, height: screenSize.width * 0.55)
                        )
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
        ), screenSize: UIScreen.main.bounds.size
    )
}

