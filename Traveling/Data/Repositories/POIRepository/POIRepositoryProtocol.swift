//
//  POIRepository.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 24-11-25.
//

import Foundation

protocol POIRepositoryProtocol {
    func searchRadius(params: POIRadiusParametersDomainModel) async throws -> [POIDomainModel]
    func searchBoundingBox(params: POIBoundingBoxParametersDomainModel) async throws -> [POIDomainModel]
    func getById(_ id: String) async throws -> POIDomainModel
}


