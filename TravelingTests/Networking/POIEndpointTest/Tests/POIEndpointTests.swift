//
//  POIEndpointTests.swift
//  TravelingTests
//
//  Created by Rodolfo Gonzalez on 16-12-25.
//

import Testing
@testable import Traveling
import Foundation

/// Test suite for validating the behavior of `POIEndpoint`.
///
/// These tests ensure that:
/// - All POI endpoints use the correct HTTP method
/// - Endpoint paths are generated correctly for each use case
/// - Query parameters are included or omitted as expected
/// - Endpoints can be composed into valid URLs
@Suite("POIEndpoint Tests")
struct POIEndpointTests {
    
    // MARK: - HTTP Method
    
    @Test("All POI endpoints use HTTP GET")
    func usesGETMethod() {
        let radius = POIEndpoint.searchRadius(mockRadiusParams())
        let box = POIEndpoint.searchBoundingBox(mockBoundingParams())
        let byId = POIEndpoint.getById("123")
        
        #expect(radius.method == .get)
        #expect(box.method == .get)
        #expect(byId.method == .get)
    }
    
    // MARK: - Path Generation
    
    @Test("Search radius endpoint generates base POI path")
    func searchRadiusPath() {
        let endpoint = POIEndpoint.searchRadius(mockRadiusParams())
        
        #expect(endpoint.path == "/v1/reference-data/locations/pois")
    }
    
    @Test("Search bounding box endpoint appends by-square")
    func searchBoundingBoxPath() {
        let endpoint = POIEndpoint.searchBoundingBox(mockBoundingParams())
        
        #expect(endpoint.path == "/v1/reference-data/locations/pois/by-square")
    }
    
    @Test("Get by ID endpoint includes identifier in path")
    func getByIdPath() {
        let endpoint = POIEndpoint.getById("poi_123")
        
        #expect(endpoint.path == "/v1/reference-data/locations/pois/poi_123")
    }
    
    // MARK: - Query Parameters
    
    @Test("Search endpoints provide query items")
    func searchEndpointsHaveQueryItems() {
        let radius = POIEndpoint.searchRadius(mockRadiusParams())
        let box = POIEndpoint.searchBoundingBox(mockBoundingParams())
        
        #expect(radius.queryItems != nil)
        #expect(box.queryItems != nil)
    }
    
    @Test("Get by ID endpoint has no query items")
    func getByIdHasNoQueryItems() {
        let endpoint = POIEndpoint.getById("poi_123")
        
        #expect(endpoint.queryItems == nil)
    }
    
    // MARK: - Integration Test
    
    @Test("Endpoints produce valid URLs")
    func buildsValidURL() {
        let endpoint = POIEndpoint.searchRadius(mockRadiusParams())
        
        var components = URLComponents(string: "https://api.example.com")!
        components.path = endpoint.path
        components.queryItems = endpoint.queryItems
        
        let url = components.url
        #expect(url != nil)
        #expect(url?.absoluteString.contains("/v1/reference-data/locations/pois") == true)
    }
    
    // MARK: - Test Helpers
    
    private func mockRadiusParams() -> POIRadiusParametersDataModel {
        POIRadiusParametersDataModel(
            latitude: 40.7,
            longitude: -73.9,
            radius: 500,
            categories: [.restaurant],
            page: PageParameters(limit: 10),
            offset: 0
        )
    }
    
    private func mockBoundingParams() -> POIBoundingBoxParametersDataModel {
        POIBoundingBoxParametersDataModel(
            north: 40.8,
            south: 40.7,
            east: -73.9,
            west: -74.0,
            categories: [.sights],
            page: PageParameters(limit: 10),
            offset: 0
        )
    }
    //ADD
    // MARK: - GET BY NAME TESTS

    @Test("Get by name endpoint appends by-name to base path")
    func getByNamePath() {
        let endpoint = POIEndpoint.getByName(mockGetByNameParams())

        #expect(endpoint.path == "/v1/reference-data/locations/pois/by-name")
    }

    @Test("Get by name endpoint provides query items")
    func getByNameHasQueryItems() {
        let endpoint = POIEndpoint.getByName(mockGetByNameParams())

        #expect(endpoint.queryItems != nil)
        #expect(endpoint.queryItems?.isEmpty == false)
    }

    @Test("Get by name endpoint uses HTTP GET method")
    func getByNameUsesGETMethod() {
        let endpoint = POIEndpoint.getByName(mockGetByNameParams())

        #expect(endpoint.method == .get)
    }

    @Test("Get by name endpoint produces valid URL")
    func getByNameBuildsValidURL() {
        let endpoint = POIEndpoint.getByName(mockGetByNameParams())

        var components = URLComponents(string: "https://api.example.com")!
        components.path = endpoint.path
        components.queryItems = endpoint.queryItems

        let url = components.url

        #expect(url != nil)
        #expect(url?.absoluteString.contains("/v1/reference-data/locations/pois/by-name") == true)
        #expect(url?.absoluteString.contains("name=") == true)
    }

    // MARK: - Test Helper

    private func mockGetByNameParams() -> POIGetByNameParametersDataModel {
        POIGetByNameParametersDataModel(
            name: "Museum",
            categories: [.sights, .historical]
        )
    }

}
