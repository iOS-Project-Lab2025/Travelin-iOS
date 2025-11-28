//
//  POI.swift
//  TestNetworking
//
//  Created by Rodolfo Gonzalez on 25-11-25.
//

import Foundation

struct POIDataModel: Decodable {
    let id: String
    let `self`: POISelfLink
    let type: String
    let subType: String
    let name: String
    let geoCode: GeoCode
    let category: String
    let rank: Int?
    let tags: [String]?
}

struct POIDomainModel: Identifiable {
    let id: String
    let name: String
    let lat: Double
    let lon: Double
    let category: String
}
