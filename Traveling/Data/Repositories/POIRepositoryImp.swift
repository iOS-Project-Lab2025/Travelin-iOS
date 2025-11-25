//
//  POIRepositoryImp.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 24-11-25.
//

final class POIRepositoryImp: POIRepository {

    private let network: NetworkServiceProtocol

    init(network: NetworkServiceProtocol) {
        self.network = network
    }

    func searchRadius(params: POIRadiusParameters) async throws -> POIListResponse {
        try await network.execute(
            POIEndpoint.searchRadius(params),
            responseType: POIListResponse.self,
            body: nil
        )
    }

    func searchBoundingBox(params: POIBoundingBoxParameters) async throws -> POIListResponse {
        try await network.execute(
            POIEndpoint.searchBoundingBox(params),
            responseType: POIListResponse.self,
            body: nil
        )
    }

    func getById(_ id: String) async throws -> POISingleResponse {
        try await network.execute(
            POIEndpoint.getById(id),
            responseType: POISingleResponse.self,
            body: nil
        )
    }
}

