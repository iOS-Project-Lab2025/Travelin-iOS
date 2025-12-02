//
//  POIMapperImp.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 25-11-25.
//

import Foundation

// MARK: - POIMapper Implementation
///
/// `POIMapperImp` is responsible for converting between:
/// - **Domain models** used by the app's business/UI layers
/// - **Data models** used for networking and API communication
///
/// This mapping layer ensures the domain remains decoupled from backend formats
/// and prevents networking details from leaking into the rest of the application.
///
/// ## Responsibilities
/// - Convert domain radius search parameters → data-layer parameters
/// - Convert domain bounding box parameters → data-layer parameters
/// - Convert data-layer POI models → domain POI models
///
/// ## Usage Example
/// ```swift
/// let dataParams = mapper.poiRadiusDomainToData(from: radiusDomainModel)
/// let domainPOI = mapper.poiDataToDomain(from: poiDataModel)
/// ```
///
/// ## Notes
/// - Ensures consistent translation across all POI-related features.
/// - Centralized mapping improves testability and maintainability.
///
/// ## SeeAlso
/// - `POIMapperProtocol`
/// - `POIRadiusParametersDomainModel`
/// - `POIRepositoryImp`
struct POIMapperImp: POIMapperProtocol {

    /// Converts domain radius search parameters into API-ready data parameters.
    func poiRadiusDomainToData(from vm: POIRadiusParametersDomainModel) -> POIRadiusParametersDataModel {
        POIRadiusParametersDataModel(
            latitude: vm.lat,
            longitude: vm.lon,
            radius: vm.radius,
            categories: vm.categories,
            limit: vm.limit,
            offset: vm.offset
        )
    }

    /// Converts domain bounding box parameters into data-layer parameters.
    func poiBoundingDomainToData(from vm: POIBoundingBoxParametersDomainModel) -> POIBoundingBoxParametersDataModel {
        POIBoundingBoxParametersDataModel(
            north: vm.north,
            south: vm.south,
            east: vm.east,
            west: vm.west,
            categories: vm.categories,
            limit: vm.limit,
            offset: vm.offset
        )
    }

    /// Converts an API POI data model into its domain representation.
    func poiDataToDomain(from data: POIDataModel) -> POIDomainModel {
        POIDomainModel(
            id: data.id,
            name: data.name,
            lat: data.geoCode.latitude,
            lon: data.geoCode.longitude,
            category: data.category
        )
    }
}
