//
//  ReusableCountriesView.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 10-12-25.
//

import SwiftUI

struct ReusableCountriesView: View {
    let country: Country
    let size: CGSize
    
    
    var body: some View {
        ZStack {
            Image(country.imageURL)
                .resizable()
                .scaledToFill()
                .frame(width: size.width, height: size.height)
                .clipped()
                .overlay(Color.black.opacity(0.13))
        }
        .overlay(alignment: .bottomLeading) {
            Text(country.name)
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(.white)
                .padding(16)
        }
        
        .frame(width: size.width, height: size.height)
    }
}



#Preview {
    ReusableCountriesView(country: Country(
        id: UUID(),
        name: "Cambodia",
        imageURL: "country1"
    ), size: CGSize(width: UIScreen.main.bounds.width * 0.5, height: UIScreen.main.bounds.width * 0.55))
    
    
}

