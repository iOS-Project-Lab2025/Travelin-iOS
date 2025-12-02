//
//  POIRadiusParametersDataModel.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 24-11-25.
//

import Foundation

// MARK: - POIRadiusParametersDataModel
///
/// Represents the **data-layer model** used to send radius-based search
/// parameters to the POI backend API.
///
/// This model conforms to `QueryParametersProtocol`, meaning it can
/// automatically convert its stored properties into URL query items.
///
/// ## Fields
/// - `latitude`: Center point latitude
/// - `longitude`: Center point longitude
/// - `radius`: Optional search radius (meters)
/// - `categories`: Optional category filters
/// - `limit`: Optional max number of results
/// - `offset`: Optional pagination offset
///
/// ## Responsibilities
/// - Provide the raw API request parameters for radius POI search
/// - Convert into query items using `toQueryItems()`
///
/// ## Usage Example
/// ```swift
/// let params = POIRadiusParametersDataModel(
///     latitude: 40.7,
///     longitude: -73.9,
///     radius: 500,
///     categories: [.food, .hotel],
///     limit: 20,
///     offset: 0
/// )
///
/// let queryItems = params.toQueryItems()
/// ```
///
/// ## Notes
/// - Typically created indirectly through a domain model using `POIMapperImp`.
/// - Used inside `POIEndpoint.searchRadius`.
///
/// ## SeeAlso
/// - `QueryParametersProtocol`
/// - `POIRadiusParametersDomainModel`
struct POIRadiusParametersDataModel: QueryParametersProtocol {
    let latitude: Double
    let longitude: Double
    let radius: Double?
    let categories: [POICategory]?
    let limit: Int?
    let offset: Int?
}

// MARK: - POIRadiusParametersDomainModel
///
/// Represents the **domain-layer model** used by UI and business logic.
/// This model is later converted into a data-layer model via `POIMapperImp`.
///
/// ## Fields
/// - `lat`, `lon`: Center coordinates
/// - `radius`: Required search radius
/// - `categories`: Optional category filters
/// - `limit`: Optional max result count
/// - `offset`: Optional pagination offset
///
/// ## Usage Example
/// ```swift
/// let domainParams = POIRadiusParametersDomainModel(
///     lat: 40.7,
///     lon: -73.9,
///     radius: 500,
///     categories: nil,
///     limit: 20,
///     offset: 0
/// )
/// ```
///
/// ## Notes
/// - Mapping to the data model is handled by `POIMapperImp`.
///
/// ## SeeAlso
/// - `POIRadiusParametersDataModel`
struct POIRadiusParametersDomainModel {
    var lat: Double
    var lon: Double
    var radius: Double
    var categories: [POICategory]?
    var limit: Int?
    var offset: Int?
}
