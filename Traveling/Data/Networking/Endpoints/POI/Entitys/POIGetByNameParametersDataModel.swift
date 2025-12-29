//
//  POIGetByNameParametersDataModel.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 18-12-25.
//

import Foundation

// MARK: - POIGetByNameParametersDataModel
///
/// Represents the **data-layer model** used to send name-based search
/// parameters to the POI backend API.
///
/// This model conforms to `QueryParametersProtocol`, allowing its
/// properties to be automatically converted into URL query items.
///
/// ## Fields
/// - `name`: Text query used to search POIs by name
/// - `categories`: Optional category filters applied to the search
///
/// ## Responsibilities
/// - Provide raw API request parameters for name-based POI search
/// - Convert stored values into URL query items
///
/// ## Usage Example
/// ```swift
/// let params = POIGetByNameParametersDataModel(
///     name: "Museum",
///     categories: [.culture, .tourism]
/// )
///
/// let queryItems = params.toQueryItems()
/// ```
///
/// ## Notes
/// - Typically created indirectly from a domain model via `POIMapperImp`.
/// - Used by `POIEndpoint.getByName`.
///
/// ## SeeAlso
/// - `QueryParametersProtocol`
/// - `POIGetByNameParametersDomainModel`
struct POIGetByNameParametersDataModel: QueryParametersProtocol {
    var name: String
    var categories: [POICategory]?
    var page: PageParameters?
}

// MARK: - POIGetByNameParametersDomainModel
///
/// Represents the **domain-layer model** used by business logic and UI
/// to perform name-based POI searches.
///
/// This model is converted into a data-layer model through `POIMapperImp`
/// before being sent to the backend.
///
/// ## Fields
/// - `name`: Text query used to search POIs by name
/// - `categories`: Optional category filters
///
/// ## Usage Example
/// ```swift
/// let domainParams = POIGetByNameParametersDomainModel(
///     name: "Museum",
///     categories: nil
/// )
/// ```
///
/// ## Notes
/// - Mapping to the data-layer model is handled by `POIMapperImp`.
///
/// ## SeeAlso
/// - `POIGetByNameParametersDataModel`
struct POIGetByNameParametersDomainModel {
    var name: String
    var categories: [POICategory]?
    var page: PageParameters?
}
