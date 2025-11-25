//
//  POIRepository.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 24-11-25.
//

import Foundation

protocol POIRepository {
    func searchRadius(params: POIRadiusParameters) async throws -> POIListResponse
    func searchBoundingBox(params: POIBoundingBoxParameters) async throws -> POIListResponse
    func getById(_ id: String) async throws -> POISingleResponse
}


