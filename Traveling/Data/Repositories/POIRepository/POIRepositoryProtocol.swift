//
//  POIRepository.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 24-11-25.
//

import Foundation

// MARK: - POI Repository Protocol
///
/// Defines the contract for repositories that provide access to
/// Points of Interest (POI) domain data.
///
/// This protocol abstracts all interactions required by higher layers
/// such as view models, use cases, or controllers.
///
/// ## Responsibilities
/// - Search POIs by radius
/// - Search POIs within a bounding box
/// - Retrieve a POI by its unique identifier
///
/// ## Usage Example
/// ```swift
/// let pois = try await repository.searchRadius(params: radiusParams)
/// let poi = try await repository.getById("123")
/// ```
/// ## Notes
/// - All methods are asynchronous and throwable.
/// - Domain models are returned, ensuring UI and business layers remain decoupled from data and networking.
///
/// ## SeeAlso
/// - `POIRepositoryImp`
/// - `POIMapperProtocol`
/// - `NetworkServiceProtocol`
protocol POIRepositoryProtocol {

    /// Searches for POIs within a radius from a center coordinate.
    func searchRadius(params: POIRadiusParametersDomainModel) async throws -> [POIDomainModel]

    /// Searches for POIs within a bounding coordinate box.
    func searchBoundingBox(params: POIBoundingBoxParametersDomainModel) async throws -> [POIDomainModel]

    /// Searches for POIs by name or text query.
    func searchByName(params: POIGetByNameParametersDomainModel) async throws -> [POIDomainModel]

    /// Retrieves a single POI by ID.
    func getById(_ id: String) async throws -> POIDomainModel

}
