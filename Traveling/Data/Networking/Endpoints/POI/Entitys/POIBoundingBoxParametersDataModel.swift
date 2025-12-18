//
//  POIBoundingBoxParametersDataModel.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 24-11-25.
//

import Foundation

// MARK: - POIBoundingBoxParametersDataModel
///
/// Represents the **data-layer model** used to send bounding-box search parameters
/// to the POI backend API.
///
/// This model conforms to `QueryParametersProtocol`, meaning it can automatically
/// convert its stored properties into URL query items.
///
/// ## Fields
/// - `north`, `south`, `east`, `west`: Coordinates defining the bounding box.
/// - `categories`: Optional list of POI categories to filter.
/// - `limit`: Optional maximum number of results.
/// - `offset`: Optional pagination offset.
///
/// ## Responsibilities
/// - Provide the raw network request parameters for bounding-box POI search.
/// - Convert stored values into URL query items through `toQueryItems()`.
///
/// ## Usage Example
/// ```swift
/// let dataParams = POIBoundingBoxParametersDataModel(
///     north: 50.0, south: 49.0, east: 8.0, west: 7.0,
///     categories: [.food, .hotel],
///     limit: 20, offset: 0
/// )
///
/// let queryItems = dataParams.toQueryItems()
/// ```
///
/// ## Notes
/// - Used by `POIRepositoryImp` via mapper conversion from domain → data model.
/// - Works directly as associated values in `POIEndpoint.searchBoundingBox`.
///
/// ## SeeAlso
/// - `QueryParametersProtocol`
/// - `POIBoundingBoxParametersDomainModel`
/// - `POIEndpoint`
struct POIBoundingBoxParametersDataModel: QueryParametersProtocol {
    let north: Double
    let south: Double
    let east: Double
    let west: Double
    let categories: [POICategory]?
    let page: PageParameters?
    let offset: Int?

    /// Returns a string representation of the west coordinate.
    /// (Possibly used by debugging or legacy logic)
    func getPoint() -> String {
        return "\(west)"
    }
}


// MARK: - POIBoundingBoxParametersDomainModel
///
/// Domain-layer counterpart used by the app's business/UI components.
/// This model is later converted into the data model using `POIMapperImp`.
///
/// ## Notes
/// - Mirrors the fields of the data model.
/// - Keeps domain concerns separated from API formatting.
///
/// ## Usage Example
/// ```swift
/// let domainParams = POIBoundingBoxParametersDomainModel(
///     north: 50, south: 49, east: 8, west: 7,
///     categories: nil, limit: 10, offset: 0
/// )
/// ```
struct POIBoundingBoxParametersDomainModel {
    var north: Double
    var south: Double
    var east: Double
    var west: Double
    var categories: [POICategory]?
    let page: PageParameters?
    var offset: Int?
}


