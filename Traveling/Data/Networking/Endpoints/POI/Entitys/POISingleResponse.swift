//
//  POISingleResponse.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 24-11-25.
//

import Foundation

/// MARK: - POISingleResponse
///
/// Represents the API response when fetching a **single Point of Interest (POI)**.
/// This structure wraps the returned POI data model.
///
/// ## Fields
/// - `data`: The POI returned by the backend.
///
/// ## Usage Example
/// ```swift
/// let response = try decoder.decode(POISingleResponse.self, from: json)
/// print(response.data.name)
/// ```
///
/// ## Notes
/// - Used by `POIRepositoryImp` when calling `getById`.
/// - Always contains exactly one POI.
///
/// ## SeeAlso
/// - `POIDataModel`
/// - `POIListResponse`
struct POISingleResponse: Decodable {
    let data: POIDataModel
}

/// MARK: - POIListResponse
///
/// Represents an API response containing **multiple Points of Interest**.
/// This structure is used for search operations such as:
/// - radius search
/// - bounding box search
///
/// ## Fields
/// - `data`: Array of POI data models
/// - `meta`: Metadata describing pagination and result count
///
/// ## Usage Example
/// ```swift
/// let list = try decoder.decode(POIListResponse.self, from: json)
/// print(list.data.count)
/// ```
///
/// ## Notes
/// - The `meta` field contains pagination and link information.
/// - Mapped to domain models via `POIMapperImp`.
///
/// ## SeeAlso
/// - `POIDataModel`
/// - `Meta`
struct POIListResponse: Decodable {
    let data: [POIDataModel]
    let meta: Meta
}

// MARK: - Self Link
///
/// Hypermedia link structure associated with a POI resource.
/// Contains navigation information for the API.
///
/// ## Fields
/// - `href`: URL pointing to the resource
/// - `methods`: HTTP methods available for this resource
///
/// ## SeeAlso
/// - `POIDataModel`
struct POISelfLink: Decodable {
    let href: String
    let methods: [String]
}

// MARK: - GeoCode
///
/// Represents the geographic coordinates of a POI.
///
/// ## Fields
/// - `latitude`: Latitude of the POI
/// - `longitude`: Longitude of the POI
///
/// ## Usage Example
/// ```swift
/// let coord = poi.geoCode
/// print(coord.latitude, coord.longitude)
/// ```
///
/// ## Notes
/// - Used by `POIMapperImp` to construct domain models.
struct GeoCode: Decodable {
    let latitude: Double
    let longitude: Double
}

// MARK: - Meta
///
/// Contains metadata returned by POI list responses.
///
/// ## Fields
/// - `count`: Number of results returned
/// - `links`: Pagination-related links
///
/// ## Notes
/// - Used for pagination and navigation within large result sets.
///
/// ## SeeAlso
/// - `PaginationLinks`
struct Meta: Decodable {
    let count: Int
    let links: PaginationLinks
}

// MARK: - PaginationLinks
///
/// Represents hypermedia links used for navigating paginated POI results.
///
/// ## Fields
/// - `selfLink`: URL for the current page
/// - `first`: URL for the first page
/// - `last`: URL for the last page
/// - `next`: URL for the next page
/// - `up`: URL for navigating upward in the hierarchy
///
/// ## Notes
/// - The backend uses `"self"` as a field name, which is mapped to `selfLink`.
struct PaginationLinks: Decodable {
    let selfLink: String?
    let first: String?
    let last: String?
    let next: String?
    let up: String?
    
    enum CodingKeys: String, CodingKey {
        case selfLink = "self"
        case first, last, next, up
    }
}



