//
//  POIDataModel.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 25-11-25.
//

import Foundation

// MARK: - POIDataModel
///
/// Represents the **data-layer POI model** returned by the remote API.
/// This struct mirrors the backend response exactly and is used for decoding
/// raw JSON data.
///
/// ## Fields
/// - `id`: Unique identifier of the POI.
/// - `self`: Hypermedia link containing reference information.
/// - `type`: Object type (usually `"location"`).
/// - `subType`: Subclassification of the POI (e.g., `"POINT_OF_INTEREST"`).
/// - `name`: Display name of the POI.
/// - `geoCode`: Coordinates (latitude/longitude).
/// - `category`: Category identifier as defined by the API.
/// - `rank`: Optional ranking or popularity index.
/// - `tags`: Optional array describing attributes of the POI.
///
/// ## Responsibilities
/// - Decode POI JSON responses from the API.
/// - Act as an intermediate model before being converted into a domain model.
///
/// ## Usage Example
/// ```swift
/// let poi = try decoder.decode(POIDataModel.self, from: jsonData)
/// print(poi.name)
/// ```
///
/// ## Notes
/// - Conversion to domain models is handled in `POIMapperImp`.
/// - `self` is escaped with backticks because it is a reserved keyword in Swift.
///
/// ## SeeAlso
/// - `POIDomainModel`
/// - `GeoCode`
/// - `POIMapperImp`
struct POIDataModel: Decodable {
    let id: String
    let `self`: POISelfLink
    let type: String
    let pictures: [String]?
    let subType: String
    let name: String
    let geoCode: GeoCode
    let category: String
    let rank: Int?
    let tags: [String]?
}

