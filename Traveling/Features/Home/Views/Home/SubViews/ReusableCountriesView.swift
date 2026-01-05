//
//  ReusableCountriesView.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 10-12-25.
//

import SwiftUI
import TravelinDesignSystem

struct ReusableCountriesView: View {
    let country: Country
    let screenSize: CGSize
    
    var body: some View {
        ZStack {
            self.countryView
        }
        .overlay(alignment: .bottomLeading) {
            self.countryNameView
        }
        .frame(width: self.screenSize.width, height: self.screenSize.height)
    }
    private var countryView: some View {
        Image(self.country.imageURL)
            .resizable()
            .scaledToFill()
            .frame(width: self.screenSize.width, height: self.screenSize.height)
            .clipped()
            .overlay(Color.black.opacity(0.13))
    }
    private var countryNameView: some View {
        Text(self.country.name)
            .font(TravelinDesignSystem.DesignTokens.Typography.title1.bold())
            .foregroundStyle(.white)
            .padding(TravelinDesignSystem.DesignTokens.Spacing.medium)
    }
}

#Preview {
    ReusableCountriesView(country: Country(
        id: UUID(),
        name: "Cambodia",
        imageURL: "country1"
    ), screenSize: CGSize(width: UIScreen.main.bounds.width * 0.5, height: UIScreen.main.bounds.width * 0.55))
    
}
