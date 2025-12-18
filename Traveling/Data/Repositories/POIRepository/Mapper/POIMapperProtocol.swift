//
//  POIMapperProtocol.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 25-11-25.
//

import Foundation

// MARK: - POIMapper Protocol
///
/// Defines a contract for mapping between:
/// - Domain models (used by business/UI)
/// - Data models (used by API/network layer)
///
/// This abstraction ensures that the translation between layers remains
/// consistent and testable.
///
/// ## Responsibilities
/// - Convert domain search parameters to data-layer request models
/// - Convert API POI data models into domain POI models
///
/// ## Usage Example
/// ```swift
/// let dataModel = mapper.poiRadiusDomainToData(from: domainParams)
/// let domainModel = mapper.poiDataToDomain(from: response.data)
/// ```
///
/// ## Notes
/// - Implemented by `POIMapperImp`
/// - Used primarily by `POIRepositoryImp`
///
/// ## SeeAlso
/// - `POIMapperImp`
/// - `POIRepositoryProtocol`
protocol POIMapperProtocol {

    /// Maps domain radius parameters → data-layer request parameters.
    func poiRadiusDomainToData(from vm: POIRadiusParametersDomainModel) -> POIRadiusParametersDataModel

    /// Maps domain bounding box parameters → data-layer request parameters.
    func poiBoundingDomainToData(from vm: POIBoundingBoxParametersDomainModel) -> POIBoundingBoxParametersDataModel

    /// Maps domain name-based search parameters into API-ready request parameters.
    func poiGetByNameDomainToData(from vm: POIGetByNameParametersDomainModel) -> POIGetByNameParametersDataModel

    /// Maps API POI data → domain POI model.
    func poiDataToDomain(from data: POIDataModel) -> POIDomainModel

}
