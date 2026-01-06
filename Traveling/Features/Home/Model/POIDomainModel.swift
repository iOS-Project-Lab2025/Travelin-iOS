//
//  POIDomainModel.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 01-01-26.
//

import Foundation

// MARK: - POIDomainModel
///
/// Represents the **domain-layer POI model**, used by UI and business logic.
/// This struct contains only the fields required by the application.
///
/// It is intentionally simplified compared to `POIDataModel`,
/// removing API-specific metadata and focusing on core POI information.
///
/// ## Fields
/// - `id`: Identifier of the POI.
/// - `name`: Display name used in the UI.
/// - `lat`: Latitude coordinate.
/// - `lon`: Longitude coordinate.
/// - `category`: POI category.
///
/// ## Usage Example
/// ```swift
/// let domainPOI = POIDomainModel(id: "123", name: "Coffee Shop", lat: 10.0, lon: 20.0, category: "FOOD")
/// ```
///
/// ## Notes
/// - Instances are produced by `POIMapperImp`.
/// - Conforms to `Identifiable` for SwiftUI and List usage.
///
/// ## SeeAlso
/// - `POIDataModel`
/// - `POIMapperImp`
struct POIDomainModel: Identifiable {
    let id: String
    let name: String
    let pictures: [String]?
    let lat: Double
    let lon: Double
    let category: String
}
