//
//  POIMapperImpTests.swift
//  TravelingTests
//
//  Created by Rodolfo Gonzalez on 16-12-25.
//

import Testing
@testable import Traveling
import Foundation

@Suite("POIMapperImp Tests")
struct POIMapperImpTests {

    // MARK: - RADIUS MAPPING TESTS

    @Test("poiRadiusDomainToData should correctly map all radius fields")
    func test_radiusDomainToData_mapsCorrectly() {

        // Arrange - given
        let mapper = POIMapperImp()
        let domainModel = POIRadiusParametersDomainModel(
            lat: 1.1,
            lon: 2.2,
            radius: 300,
            categories: [.restaurant, .shopping],
            limit: 50,
            offset: 10
        )

        // Act - Then
        let result = mapper.poiRadiusDomainToData(from: domainModel)

        // Assert - Expect
        #expect(result.latitude == 1.1)
        #expect(result.longitude == 2.2)
        #expect(result.radius == 300)
        #expect(result.categories == [.restaurant, .shopping])
        #expect(result.limit == 50)
        #expect(result.offset == 10)
    }

    // MARK: - BOUNDING BOX MAPPING TESTS

    @Test("poiBoundingDomainToData should correctly map bounding box parameters")
    func test_boundingDomainToData_mapsCorrectly() {

        // Arrange - given
        let mapper = POIMapperImp()
        let domainModel = POIBoundingBoxParametersDomainModel(
            north: 10,
            south: 5,
            east: 8,
            west: 3,
            categories: [.restaurant],
            limit: 20,
            offset: 5
        )

        // Act - Then
        let result = mapper.poiBoundingDomainToData(from: domainModel)

        // Assert - Expect
        #expect(result.north == 10)
        #expect(result.south == 5)
        #expect(result.east == 8)
        #expect(result.west == 3)
        #expect(result.categories == [.restaurant])
        #expect(result.limit == 20)
        #expect(result.offset == 5)
    }

    // MARK: - DATA → DOMAIN MAPPING TESTS

    @Test("poiDataToDomain should correctly map POIDataModel into POIDomainModel")
    func test_poiDataToDomain_mapsCorrectly() {

        // Arrange - given
        let mapper = POIMapperImp()
        let dataModel = POIDataModel(
            id: "10",
            self: POISelfLink(href: "http://test.com", methods: []),
            type: "Landmark",
            subType: "Historic",
            name: "Castle",
            geoCode: GeoCode(latitude: 40.0, longitude: -3.0),
            category: "HISTORICAL",
            rank: nil,
            tags: []
        )

        // Act - Then
        let result = mapper.poiDataToDomain(from: dataModel)

        // Assert - Expect
        #expect(result.id == "10")
        #expect(result.name == "Castle")
        #expect(result.lat == 40.0)
        #expect(result.lon == -3.0)
        #expect(result.category == "HISTORICAL")
    }
}

