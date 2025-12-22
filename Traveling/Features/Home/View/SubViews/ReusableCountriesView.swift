//
//  ReusableCountriesView.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 10-12-25.
//

import SwiftUI

struct ReusableCountriesView: View {
    let country: Country

    var body: some View {
        ZStack {
            Image(country.imageURL)
                .resizable()
                .aspectRatio(1, contentMode: .fill)
                .clipped()
                .overlay {
                    Color.black.opacity(0.13)
                }

            VStack {
                Spacer()

                Text(country.name)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(.white)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxWidth: .infinity)
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}


#Preview {
    ReusableCountriesView(country: Country(
        id: UUID(),
        name: "Cambodia",
        imageURL: "country1"
    ))
    .frame(width: UIScreen.main.bounds.width * 0.5, height: UIScreen.main.bounds.width * 0.8 )
    
}

