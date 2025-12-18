//
//  POIMapperImpTests.swift
//  TravelingTests
//
//  Created by Rodolfo Gonzalez on 16-12-25.
//

import Testing
@testable import Traveling
import Foundation

/// Test suite for validating the behavior of `POIMapperImp`.
///
/// This suite focuses exclusively on mapping correctness between:
/// - Domain models → Data models
/// - Data models → Domain models
///
/// The goal is to ensure that no information is lost, altered,
/// or incorrectly transformed during the mapping process.
@Suite("POIMapperImp Tests")
struct POIMapperImpTests {

    // MARK: - Radius Mapping Tests

    /// Verifies that `poiRadiusDomainToData` correctly maps
    /// all radius-based search parameters from the domain layer
    /// into the data layer.
    ///
    /// This test validates:
    /// - Geographic coordinates (latitude and longitude)
    /// - Search radius
    /// - Category filters
    /// - Pagination parameters (limit and offset)
    @Test("poiRadiusDomainToData should correctly map all radius fields")
    func test_radiusDomainToData_mapsCorrectly() {

        // Arrange
        // Given a domain model with predefined radius search parameters
        let mapper = POIMapperImp()
        let domainModel = POIRadiusParametersDomainModel(
            lat: 1.1,
            lon: 2.2,
            radius: 300,
            categories: [.restaurant, .shopping],
            page: PageParameters(limit: 50),
            offset: 10
        )

        // Act
        // When mapping the domain model to a data model
        let result = mapper.poiRadiusDomainToData(from: domainModel)

        // Assert
        // Then all properties should be mapped without modification
        #expect(result.latitude == 1.1)
        #expect(result.longitude == 2.2)
        #expect(result.radius == 300)
        #expect(result.categories == [.restaurant, .shopping])
        #expect(result.page?.limit == 50)
        #expect(result.offset == 10)
    }

    // MARK: - Bounding Box Mapping Tests

    /// Verifies that `poiBoundingDomainToData` correctly maps
    /// bounding box search parameters from the domain layer
    /// into the data layer.
    ///
    /// This includes:
    /// - Geographic bounds (north, south, east, west)
    /// - Category filters
    /// - Pagination parameters
    @Test("poiBoundingDomainToData should correctly map bounding box parameters")
    func test_boundingDomainToData_mapsCorrectly() {

        // Arrange
        // Given a domain model representing a bounding box search
        let mapper = POIMapperImp()
        let domainModel = POIBoundingBoxParametersDomainModel(
            north: 10,
            south: 5,
            east: 8,
            west: 3,
            categories: [.restaurant],
            page: PageParameters(limit: 20),
            offset: 5
        )

        // Act
        // When mapping the domain model to a data model
        let result = mapper.poiBoundingDomainToData(from: domainModel)

        // Assert
        // Then all bounding box and pagination values must match exactly
        #expect(result.north == 10)
        #expect(result.south == 5)
        #expect(result.east == 8)
        #expect(result.west == 3)
        #expect(result.categories == [.restaurant])
        #expect(result.page?.limit == 20)
        #expect(result.offset == 5)
    }

    // MARK: - Data → Domain Mapping Tests

    /// Verifies that `poiDataToDomain` correctly transforms
    /// a `POIDataModel` into a `POIDomainModel`.
    ///
    /// This test ensures that:
    /// - Identifiers are preserved
    /// - Coordinates are correctly extracted from the geoCode
    /// - Core descriptive fields remain unchanged
    @Test("poiDataToDomain should correctly map POIDataModel into POIDomainModel")
    func test_poiDataToDomain_mapsCorrectly() {

        // Arrange
        // Given a data model typically returned by a remote data source
        let mapper = POIMapperImp()
        let dataModel = POIDataModel(
            id: "10",
            self: POISelfLink(href: "http://test.com", methods: []),
            type: "Landmark",
            pictures: [],
            subType: "Historic",
            name: "Castle",
            geoCode: GeoCode(latitude: 40.0, longitude: -3.0),
            category: "HISTORICAL",
            rank: nil,
            tags: []
        )

        // Act
        // When converting the data model into a domain model
        let result = mapper.poiDataToDomain(from: dataModel)

        // Assert
        // Then the resulting domain model should contain equivalent values
        #expect(result.id == "10")
        #expect(result.name == "Castle")
        #expect(result.lat == 40.0)
        #expect(result.lon == -3.0)
        #expect(result.category == "HISTORICAL")
    }
    //ADD
    // MARK: - SEARCH BY NAME MAPPING TESTS

    @Test("poiGetByNameDomainToData should correctly map name-based search parameters")
    func test_getByNameDomainToData_mapsCorrectly() {

        // Arrange - given
        let mapper = POIMapperImp()
        let domainModel = POIGetByNameParametersDomainModel(
            name: "Museum",
            categories: [.sights, .historical]
        )

        // Act - Then
        let result = mapper.poiGetByNameDomainToData(from: domainModel)

        // Assert - Expect
        #expect(result.name == "Museum")
        #expect(result.categories == [.sights, .historical])
    }

    @Test("poiGetByNameDomainToData should map nil categories correctly")
    func test_getByNameDomainToData_mapsNilCategories() {

        // Arrange - given
        let mapper = POIMapperImp()
        let domainModel = POIGetByNameParametersDomainModel(
            name: "Cafe",
            categories: nil
        )

        // Act - Then
        let result = mapper.poiGetByNameDomainToData(from: domainModel)

        // Assert - Expect
        #expect(result.name == "Cafe")
        #expect(result.categories == nil)
    }

}
