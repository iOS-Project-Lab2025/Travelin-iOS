//
//  PageParameters.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 18-12-25.
//

import Foundation

// MARK: - PageParameters
///
/// Represents **pagination-related query parameters** used by POI endpoints
/// that support paged responses.
///
/// This model is designed to be **nested inside other query parameter models**
/// and converted into bracketed query items such as:
///
/// ```text
/// page[limit]=20
/// ```
///
/// It conforms to `QueryParametersProtocol`, allowing its properties
/// to be automatically transformed into URL query items.
///
/// ## Fields
/// - `limit`: Optional maximum number of results to return per page
///
/// ## Responsibilities
/// - Represent pagination constraints in a type-safe way
/// - Enable nested query parameter generation (`page[limit]`)
///
/// ## Usage Example
/// ```swift
/// let page = PageParameters(limit: 20)
///
/// let params = POIBoundingBoxParametersDataModel(
///     north: 40.8,
///     south: 40.7,
///     east: -73.9,
///     west: -74.0,
///     categories: nil,
///     page: page,
///     offset: nil
/// )
/// ```
///
/// Resulting query string:
/// ```text
/// page[limit]=20
/// ```
///
/// ## Notes
/// - Typically used as a nested parameter within other data-layer models.
/// - Converted to query items via `QueryParametersProtocol`.
///
/// ## SeeAlso
/// - `QueryParametersProtocol`
/// - `POIBoundingBoxParametersDataModel`
struct PageParameters: QueryParametersProtocol {
    let limit: Int?
}
