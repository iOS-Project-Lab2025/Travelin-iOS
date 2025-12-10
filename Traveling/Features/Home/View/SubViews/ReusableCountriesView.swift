//
//  ReusableCountriesView.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 10-12-25.
//

import SwiftUI

struct ReusableCountriesView: View {
    var country: Country
    var body: some View {
        ZStack {
            Image(country.imageURL)
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width * 0.45, height: UIScreen.main.bounds.width * 0.45)
                .clipped()
                .overlay {
                    Color.black.opacity(0.13)
                }
            VStack {
                Spacer()
                Text(country.name)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .bold()
                    .font(.system(size: 20))
                    .foregroundStyle(.white)
                    .padding()
            }
        }
    }
}

#Preview {
    ReusableCountriesView(country: Country(
        id: UUID(),
        name: "Cambodia",
        imageURL: "country1"
    ))
}
