//
//  POIMapperImp.swift
//  TestNetworking
//
//  Created by Rodolfo Gonzalez on 25-11-25.
//

import Foundation

struct POIMapperImp: POIMapperProtocol {

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
