//
//  Package.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 10-12-25.
//

import Foundation

struct Package: Identifiable, Codable, Hashable {
    /// Unique identifier used by SwiftUI lists and navigation routes.
    /// Passed into HomeRoutes.poiDetail(id:) to open the detail screen.
    /// HomeView resolves this id back to a Binding<Package>.
    let id: String

    /// Image references used as URL strings in AsyncImage (first element is the cover).
    /// Both Home and Search list UIs use imagesCollection.first to build a URL.
    /// Keep at least one valid URL string to avoid placeholder rendering.
    let imagesCollection: [String]

    /// Display name/title for the package/POI.
    /// Rendered in Home cards, Search rows, and the detail view.
    /// Should be user-friendly and localizable if needed.
    let name: String

    /// Integer rating rendered as 0–5 filled stars in the UI.
    /// Stars are filled when rating >= (index + 1).
    /// Keep within 0...5 for consistent visuals.
    let rating: Int

    /// Total number of reviews shown next to the star rating.
    /// Displayed in both Home and Search list UIs.
    /// Used only for presentation (no calculations here).
    let numberReviews: Int

    /// Package description shown as a one-line preview in lists.
    /// Displayed fully in DetailPackageView (currently without scrolling).
    /// Keep length in mind for layout and performance.
    let description: String

    /// Mutable UI state for "favorite" selection.
    /// Toggled in ReusablePackageView via Binding<Package>.
    /// Changes propagate back to HomeViewModel.allPoiPackages.
    var isFavorite: Bool

    /// Price displayed in Search as "from $X/person".
    /// Stored as Int for simple formatting in UI.
    /// Consider currency formatting/localization in the future.
    let price: Int

    /// Additional included services/attributes for the package.
    /// Search rows display only the first item as a badge.
    /// Detail can later expand to show the full list.
    let servicesIncluded: [ServicesIncluded]
}


