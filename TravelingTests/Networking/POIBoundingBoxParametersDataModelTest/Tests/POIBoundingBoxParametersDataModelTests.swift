//
//  POIBoundingBoxParametersDataModelTests.swift
//  TravelingTests
//
//  Created by Rodolfo Gonzalez on 16-12-25.
//

import Testing
@testable import Traveling
import Foundation

@Suite("POIBoundingBoxParametersDataModel Tests")
struct POIBoundingBoxParametersDataModelTests {

    // MARK: - Core Query Behavior

    @Test("Converts bounding box coordinates into query items")
    func convertsCoordinatesToQueryItems() {
        let params = POIBoundingBoxParametersDataModel(
            north: 40.8,
            south: 40.7,
            east: -73.9,
            west: -74.0,
            categories: nil,
            limit: nil,
            offset: nil
        )

        let items = params.toQueryItems()

        #expect(items.count == 4)
        #expect(items.contains { $0.name == "north" && $0.value == "40.8" })
        #expect(items.contains { $0.name == "south" && $0.value == "40.7" })
        #expect(items.contains { $0.name == "east" && $0.value == "-73.9" })
        #expect(items.contains { $0.name == "west" && $0.value == "-74.0" })
    }

    // MARK: - Optional Handling

    @Test("Omits optional values when nil")
    func omitsNilOptionalValues() {
        let params = POIBoundingBoxParametersDataModel(
            north: 1,
            south: 2,
            east: 3,
            west: 4,
            categories: nil,
            limit: nil,
            offset: nil
        )

        let items = params.toQueryItems()

        #expect(items.count == 4)
        #expect(items.allSatisfy { $0.name != "categories" })
        #expect(items.allSatisfy { $0.name != "limit" })
        #expect(items.allSatisfy { $0.name != "offset" })
    }

    @Test("Includes optional values when present")
    func includesOptionalValues() {
        let params = POIBoundingBoxParametersDataModel(
            north: 10,
            south: 5,
            east: 8,
            west: 3,
            categories: [.restaurant, .shopping],
            limit: 20,
            offset: 0
        )

        let items = params.toQueryItems()

        #expect(items.count == 7)
        #expect(items.contains { $0.name == "limit" && $0.value == "20" })
        #expect(items.contains { $0.name == "offset" && $0.value == "0" })
        #expect(items.contains { $0.name == "categories" })
    }

    // MARK: - Array Handling

    @Test("Serializes categories as comma-separated values")
    func serializesCategories() {
        let params = POIBoundingBoxParametersDataModel(
            north: 0,
            south: 0,
            east: 0,
            west: 0,
            categories: [.restaurant, .sights],
            limit: nil,
            offset: nil
        )

        let items = params.toQueryItems()

        let categoriesItem = items.first { $0.name == "categories" }
        #expect(categoriesItem != nil)
        #expect(categoriesItem?.value?.contains(",") == true)
    }

    // MARK: - URL Usability

    @Test("Produces valid URL when used in URLComponents")
    func producesValidURL() {
        let params = POIBoundingBoxParametersDataModel(
            north: 40.8,
            south: 40.7,
            east: -73.9,
            west: -74.0,
            categories: [.restaurant],
            limit: 10,
            offset: 0
        )

        var components = URLComponents(string: "https://api.example.com/search")!
        components.queryItems = params.toQueryItems()

        #expect(components.url != nil)
    }

    // MARK: - Helper Method

    @Test("getPoint returns west coordinate as string")
    func getPointReturnsWestValue() {
        let params = POIBoundingBoxParametersDataModel(
            north: 0,
            south: 0,
            east: 0,
            west: -12.34,
            categories: nil,
            limit: nil,
            offset: nil
        )

        #expect(params.getPoint() == "-12.34")
    }
}

