//
//  ReusableCountriesView.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 10-12-25.
//

import SwiftUI
import TravelinDesignSystem

struct ReusableCountriesView: View {
    /// Immutable model for display (name + image asset key).
    /// This view does not own state; it only renders UI.
    /// Parent provides the data source (HomeViewModel.countries).
    let country: Country

    /// Controls the final card size used by image and overlays.
    /// Typically computed by the parent collection view.
    /// Keeps consistent proportions across devices.
    let screenSize: CGSize
    
    var body: some View {
        /// Base image is rendered in a ZStack to allow overlays.
        /// The title is placed using an overlay aligned bottom-leading.
        /// Frame is fixed to the provided screenSize.
        ZStack {
            self.countryView
        }
        .overlay(alignment: .bottomLeading) {
            self.countryNameView
        }
        .frame(width: self.screenSize.width, height: self.screenSize.height)
    }

    private var countryView: some View {
        /// Uses an asset name stored in country.imageURL (not a remote URL).
        /// scaledToFill + clipped ensures full coverage without distortion.
        /// A subtle dark overlay improves text readability.
        Image(self.country.imageURL)
            .resizable()
            .scaledToFill()
            .frame(width: self.screenSize.width, height: self.screenSize.height)
            .clipped()
            .overlay(Color.black.opacity(0.13))
    }

    private var countryNameView: some View {
        /// Country label rendered on top of the image.
        /// Typography and spacing come from the design system.
        /// White text contrasts with the darkened background overlay.
        Text(self.country.name)
            .font(TravelinDesignSystem.DesignTokens.Typography.title1.bold())
            .foregroundStyle(.white)
            .padding(TravelinDesignSystem.DesignTokens.Spacing.medium)
    }
}

#Preview {
    /// Preview uses a sample Country with a local asset key.
    /// Size matches the proportions used in HomeCountriesCollectionView.
    /// Useful to verify cropping and text readability.
    ReusableCountriesView(country: Country(
        id: UUID(),
        name: "Cambodia",
        imageURL: "country1"
    ), screenSize: CGSize(width: UIScreen.main.bounds.width * 0.5, height: UIScreen.main.bounds.width * 0.55))
}
