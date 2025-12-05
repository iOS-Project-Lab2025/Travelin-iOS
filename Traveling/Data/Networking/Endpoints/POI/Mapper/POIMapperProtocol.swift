//
//  POIMapper.swift
//  TestNetworking
//
//  Created by Rodolfo Gonzalez on 25-11-25.
//

import Foundation
protocol POIMapperProtocol {
    func poiRadiusDomainToData(from vm: POIRadiusParametersDomainModel) -> POIRadiusParametersDataModel
    func poiBoundingDomainToData(from vm: POIBoundingBoxParametersDomainModel) -> POIBoundingBoxParametersDataModel
    func poiDataToDomain(from data: POIDataModel) -> POIDomainModel
}

