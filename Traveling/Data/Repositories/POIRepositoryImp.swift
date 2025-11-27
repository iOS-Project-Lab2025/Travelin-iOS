//
//  POIRepositoryImp.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 24-11-25.
//

final class POIRepositoryImp: POIRepositoryProtocol {

    private let network: NetworkServiceProtocol
    private let mapper: POIMapperProtocol

    init(network: NetworkServiceProtocol, mapper: POIMapperProtocol) {
        self.network = network
        self.mapper = mapper
    }
    func searchRadius(params: POIRadiusParametersDomainModel) async throws -> [POIDomainModel] {
        var POIDomainModels: [POIDomainModel] = []
        let dataParams = mapper.poiRadiusDomainToData(from: params)
        let pOIListResponse = try await network.execute(
            POIEndpoint.searchRadius(dataParams),
            responseType: POIListResponse.self,
            body: nil
        )
        POIDomainModels = pOIListResponse.data.map { mapper.poiDataToDomain(from: $0) }
        return POIDomainModels
    }
    func searchBoundingBox(params: POIBoundingBoxParametersDomainModel) async throws -> [POIDomainModel] {
        var POIDomainModels: [POIDomainModel] = []
        let dataParams = mapper.poiBoundingDomainToData(from: params)
        let pOIListResponse = try await network.execute(
            POIEndpoint.searchBoundingBox(dataParams),
            responseType: POIListResponse.self,
            body: nil
        )
        POIDomainModels = pOIListResponse.data.map { mapper.poiDataToDomain(from: $0) }
        return POIDomainModels
    }

    func getById(_ id: String) async throws -> POIDomainModel {
        let pOIResponse = try await network.execute(
            POIEndpoint.getById(id),
            responseType: POISingleResponse.self,
            body: nil
        )
        return mapper.poiDataToDomain(from: pOIResponse.data)
    }
}

