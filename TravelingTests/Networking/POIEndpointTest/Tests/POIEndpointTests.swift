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
    
    /// Verifies that all POI-related endpoints
    /// use the HTTP GET method.
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
    
    /// Verifies that the search-by-radius endpoint
    /// generates the base POI search path.
    @Test("Search radius endpoint generates base POI path")
    func searchRadiusPath() {
        let endpoint = POIEndpoint.searchRadius(mockRadiusParams())
        
        #expect(endpoint.path == "/v1/reference-data/locations/pois")
    }
    
    /// Verifies that the search-by-bounding-box endpoint
    /// appends the expected `by-square` path segment.
    @Test("Search bounding box endpoint appends by-square")
    func searchBoundingBoxPath() {
        let endpoint = POIEndpoint.searchBoundingBox(mockBoundingParams())
        
        #expect(endpoint.path == "/v1/reference-data/locations/pois/by-square")
    }
    
    /// Verifies that the get-by-ID endpoint
    /// includes the POI identifier in the URL path.
    @Test("Get by ID endpoint includes identifier in path")
    func getByIdPath() {
        let endpoint = POIEndpoint.getById("poi_123")
        
        #expect(endpoint.path == "/v1/reference-data/locations/pois/poi_123")
    }
    
    // MARK: - Query Parameters
    
    /// Verifies that search endpoints
    /// provide query items for request configuration.
    @Test("Search endpoints provide query items")
    func searchEndpointsHaveQueryItems() {
        let radius = POIEndpoint.searchRadius(mockRadiusParams())
        let box = POIEndpoint.searchBoundingBox(mockBoundingParams())
        
        #expect(radius.queryItems != nil)
        #expect(box.queryItems != nil)
    }
    
    /// Verifies that the get-by-ID endpoint
    /// does not include any query parameters.
    @Test("Get by ID endpoint has no query items")
    func getByIdHasNoQueryItems() {
        let endpoint = POIEndpoint.getById("poi_123")
        
        #expect(endpoint.queryItems == nil)
    }
    
    // MARK: - Integration Test
    
    /// Verifies that a POI endpoint can be composed
    /// into a valid URL using `URLComponents`.
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
    
    /// Creates a mock radius-based POI search parameter set.
    private func mockRadiusParams() -> POIRadiusParametersDataModel {
        POIRadiusParametersDataModel(
            latitude: 40.7,
            longitude: -73.9,
            radius: 500,
            categories: [.restaurant],
            limit: 10,
            offset: 0
        )
    }
    
    /// Creates a mock bounding-box-based POI search parameter set.
    private func mockBoundingParams() -> POIBoundingBoxParametersDataModel {
        POIBoundingBoxParametersDataModel(
            north: 40.8,
            south: 40.7,
            east: -73.9,
            west: -74.0,
            categories: [.sights],
            limit: 10,
            offset: 0
        )
    }
}
