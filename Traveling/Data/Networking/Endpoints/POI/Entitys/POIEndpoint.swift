//
//  POIEndpoint.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 24-11-25.
//

import Foundation

/// MARK: - POIEndpoint
///
/// Defines all API endpoints related to Points of Interest (POI).
/// Each case represents a specific API route and provides:
/// - HTTP method
/// - URL path
/// - Optional query parameters
/// - Optional headers
///
/// This enum conforms to `EndPointProtocol`, allowing the networking layer
/// to build requests dynamically based on the case and its associated values.
///
/// ## Responsibilities
/// - Generate dynamic paths for POI searches and details
/// - Convert request parameter models into URL query items
/// - Represent POI API endpoints in a type-safe and maintainable way
///
/// ## Endpoints
/// - `searchRadius(...)` — Search POIs within a radius from a coordinate
/// - `searchBoundingBox(...)` — Search POIs within a bounding box
/// - `getById(...)` — Retrieve a single POI by unique identifier
///
/// ## Usage Example
/// ```swift
/// let endpoint = POIEndpoint.searchRadius(radiusParams)
/// let url = try endPointBuilder.buildURL(from: endpoint)
/// ```
///
/// ## Notes
/// - All endpoints use HTTP GET.
/// - Paths follow the Amadeus POI API format.
/// - Query parameters are automatically encoded using `QueryParametersProtocol`.
///
/// ## SeeAlso
/// - `EndPointProtocol`
/// - `QueryParametersProtocol`
/// - `POIRadiusParametersDataModel`
/// - `POIBoundingBoxParametersDataModel`
enum POIEndpoint: EndPointProtocol {

    case searchRadius(POIRadiusParametersDataModel)
    case searchBoundingBox(POIBoundingBoxParametersDataModel)
    case getById(String)

    /// Base path for all POI-related requests.
    private static let basePath = "/v1/reference-data/locations/pois"

    /// Computes the path based on the endpoint case.
    var path: String {
        switch self {
        case .searchRadius:
            return Self.basePath
        case .searchBoundingBox:
            return Self.basePath + "/by-square"
        case .getById(let id):
            return Self.basePath + "/\(id)"
        }
    }

    /// All POI endpoints use HTTP GET.
    var method: HTTPMethod { .get }

    /// Converts associated parameter models into URL query items.
    var queryItems: [URLQueryItem]? {
        switch self {
        case .searchRadius(let params):
            return params.toQueryItems()

        case .searchBoundingBox(let params):
            return params.toQueryItems()

        case .getById:
            return nil
        }
    }

    /// No custom headers for POI endpoints.
    var headers: [String : String]? { nil }
}

