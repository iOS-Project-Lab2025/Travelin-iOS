//
//  POIRepositoryImp.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 24-11-25.
//

import Foundation

// MARK: - POI Repository Implementation
///
/// `POIRepositoryImp` is the concrete implementation of `POIRepositoryProtocol`.
/// It coordinates the communication between:
/// - the networking layer (`NetworkServiceProtocol`)
/// - the data/domain transformation layer (`POIMapperProtocol`)
///
/// This repository acts as the main access point for retrieving POI (Points of Interest)
/// data from remote APIs while exposing clean domain models to the higher layers.
///
/// ## Responsibilities
/// - Convert domain request models into data-layer models.
/// - Invoke the correct API endpoints via `NetworkServiceProtocol`.
/// - Map API responses into domain models using `POIMapperProtocol`.
///
/// ## Usage Example
/// ```swift
/// let repo = POIRepositoryImp(network: service, mapper: poiMapper)
/// let pois = try await repo.searchRadius(params: radiusParams)
/// ```
///
/// ## Notes
/// - Handles three main operations:
///   - Search by radius
///   - Search within a bounding box
///   - Retrieve a POI by ID
///
/// ## SeeAlso
/// - `POIRepositoryProtocol`
/// - `POIMapperProtocol`
/// - `NetworkServiceProtocol`
/// - `POIEndpoint`
final class POIRepositoryImp: POIRepositoryProtocol {

    private let network: NetworkServiceProtocol
    private let mapper: POIMapperProtocol

    /// Initializes the repository with its dependencies.
    ///
    /// - Parameters:
    ///   - network: Performs HTTP requests and decoding.
    ///   - mapper: Handles transformations between domain and data models.
    init(network: NetworkServiceProtocol, mapper: POIMapperProtocol) {
        self.network = network
        self.mapper = mapper
    }

    /// Searches for POIs within a radius from a central coordinate.
    ///
    /// - Parameter params: Domain model representing the request parameters.
    /// - Returns: A list of domain POI models.
    /// - Throws: Networking or decoding related errors.
    func searchRadius(params: POIRadiusParametersDomainModel) async throws -> [POIDomainModel] {
        var POIDomainModels: [POIDomainModel] = []

        // Convert domain params → data params
        let dataParams = self.mapper.poiRadiusDomainToData(from: params)

        // Execute network request
        let pOIListResponse = try await self.network.execute(
            POIEndpoint.searchRadius(dataParams),
            responseType: POIListResponse.self,
            body: nil
        )

        // Map each POI into domain representation
        POIDomainModels = pOIListResponse.data.map { self.mapper.poiDataToDomain(from: $0) }
        return POIDomainModels
    }

    /// Searches for POIs within a bounding box defined by coordinates.
    ///
    /// - Parameter params: Domain model describing bounding box coordinates.
    /// - Returns: A list of domain POI models.
    /// - Throws: Any networking or mapping errors.
    func searchBoundingBox(params: POIBoundingBoxParametersDomainModel) async throws -> [POIDomainModel] {
        var POIDomainModels: [POIDomainModel] = []

        // Convert domain params → data params
        let dataParams = self.mapper.poiBoundingDomainToData(from: params)

        // Execute associated endpoint
        let pOIListResponse = try await self.network.execute(
            POIEndpoint.searchBoundingBox(dataParams),
            responseType: POIListResponse.self,
            body: nil
        )

        // Map API responses into domain models
        POIDomainModels = pOIListResponse.data.map { self.mapper.poiDataToDomain(from: $0) }
        return POIDomainModels
    }

    /// Searches for POIs by name or text query.
    ///
    /// - Parameter params: Domain model containing the search text and filters.
    /// - Returns: A list of domain POI models matching the given name.
    /// - Throws: Networking or decoding related errors.
    func searchByName(params: POIGetByNameParametersDomainModel) async throws -> [POIDomainModel] {
        let dataParams = mapper.poiGetByNameDomainToData(from: params)

        let response = try await network.execute(
            POIEndpoint.getByName(dataParams),
            responseType: POIListResponse.self,
            body: nil
        )

        return response.data.map(mapper.poiDataToDomain(from:))
    }
    /// Retrieves a single POI by its unique identifier.
    ///
    /// - Parameter id: The POI ID.
    /// - Returns: A mapped domain POI model.
    /// - Throws: Networking or decoding errors.
    func getById(_ id: String) async throws -> POIDomainModel {
        let pOIResponse = try await self.network.execute(
            POIEndpoint.getById(id),
            responseType: POISingleResponse.self,
            body: nil
        )
        return self.mapper.poiDataToDomain(from: pOIResponse.data)
    }
}
