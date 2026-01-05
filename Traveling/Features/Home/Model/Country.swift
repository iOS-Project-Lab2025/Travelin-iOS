//
//  Country.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 05-01-26.
//

import Foundation

struct Country: Identifiable {
    /// Stable identity for SwiftUI diffing in ForEach and list rendering.
    /// Using UUID keeps each country item uniquely identifiable.
    /// Required by Identifiable conformance.
    let id: UUID

    /// Human-readable country name displayed in the UI overlay.
    /// Used by ReusableCountriesView as the bottom-left label.
    /// Keep it concise for better readability on images.
    let name: String

    /// Image key used by SwiftUI Image(...) in this project (asset name).
    /// Despite the name, it is not currently a remote URL.
    /// Must match a valid image in the app asset catalog.
    let imageURL: String
}
