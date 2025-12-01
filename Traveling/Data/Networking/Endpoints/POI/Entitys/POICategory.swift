//
//  POICategory.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 25-11-25.
//

import Foundation

/// MARK: - POICategory
///
/// Represents the different **categories of Points of Interest (POI)** supported by the app.
/// These categories are sent to the backend as filters and are also displayed in the UI.
///
/// Conforms to:
/// - `RawRepresentable (String)` — for API compatibility
/// - `CaseIterable` — allows iterating all categories
/// - `CustomStringConvertible` — converts category to readable text
/// - `Encodable` — allows use in API request bodies or query models
///
/// ## Categories
/// - `sights`: General tourist sights
/// - `beachPark`: Beaches or parks
/// - `historical`: Historical locations or landmarks
/// - `nightlife`: Entertainment/nightlife venues
/// - `restaurant`: Restaurants and eating places
/// - `shopping`: Retail or commercial areas
///
/// ## Usage Example
/// ```swift
/// let categories: [POICategory] = [.restaurant, .sights]
/// let queryValue = categories.map { $0.description }.joined(separator: ",")
/// ```
///
/// ## Notes
/// - `description` returns the raw API value (e.g., `"RESTAURANT"`).
/// - Used in radius and bounding-box search parameter models.
///
/// ## SeeAlso
/// - `POIRadiusParametersDataModel`
/// - `POIBoundingBoxParametersDataModel`
enum POICategory: String, CaseIterable, CustomStringConvertible, Encodable {
    case sights = "SIGHTS"
    case beachPark = "BEACH_PARK"
    case historical = "HISTORICAL"
    case nightlife = "NIGHTLIFE"
    case restaurant = "RESTAURANT"
    case shopping = "SHOPPING"

    /// Returns the raw string value used by the backend API.
    var description: String { rawValue }
}

