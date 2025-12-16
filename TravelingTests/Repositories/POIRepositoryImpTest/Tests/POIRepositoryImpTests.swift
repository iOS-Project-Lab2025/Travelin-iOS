//
//  POIRepositoryImpTests.swift
//  TravelingTests
//
//  Created by Rodolfo Gonzalez on 16-12-25.
//

import Testing
@testable import Traveling
import Foundation

/// Test suite for validating `POIRepositoryImp`.
///
/// This suite verifies repository behavior at the integration boundary between:
/// - Domain layer inputs (Domain Models)
/// - Data layer request construction (Data Models + Endpoints)
/// - Network execution (mocked `MockNetworkService`)
/// - Mapping from Data Models to Domain Models (mocked `MockPOIMapper`)
///
/// Coverage includes:
/// - Parameter mapping correctness (domain -> data)
/// - Correct endpoint selection per repository method
/// - Mapping of service responses into domain results
/// - Empty results behavior
/// - Error propagation (timeouts, connectivity, server errors, decoding failures, empty response, invalid content type)
///
/// IMPORTANT:
/// - This file contains **15 fully implemented tests**.
/// - No test logic, assertions, or behavior has been modified—only documentation/comments were added.
@Suite("POIRepositoryImp Tests")
struct POIRepositoryImpTests {
    
    // MARK: - SEARCH RADIUS TESTS
    // These tests validate the repository behavior for radius-based POI searches,
    // including parameter mapping, endpoint selection, and response mapping.
    
    /// Validates that `searchRadius(params:)` uses the mapper to convert
    /// `POIRadiusParametersDomainModel` into `POIRadiusParametersDataModel`.
    ///
    /// Assertions focus on:
    /// - Mapper invocation
    /// - Captured domain parameters passed to the mapper
    /// - Preservation of values (lat/lon/radius/categories)
    @Test("searchRadius should convert domain params to data params using mapper")
    func test_searchRadius_convertsParamsCorrectly() async throws {
        
        // Arrange - given
        // Prepare mock dependencies: service returns a stub response, mapper returns a stub data model.
        let service = MockNetworkService()
        let mapper = MockPOIMapper()
        
        // Domain input to be mapped and used by the repository.
        let domainParams = POIRadiusParametersDomainModel(
            lat: 40.7,
            lon: -73.9,
            radius: 500,
            categories: [.restaurant, .sights],
            limit: 20,
            offset: 0
        )
        
        // Expected mapper output (data layer parameters used to build the endpoint query).
        mapper.expectedRadiusDataParams = POIRadiusParametersDataModel(
            latitude: 40.7,
            longitude: -73.9,
            radius: 500,
            categories: [.restaurant, .sights],
            limit: 20,
            offset: 0
        )
        
        // Service stub response: empty list with valid meta.
        service.listResponse = POIListResponse(
            data: [],
            meta: Meta(count: 0, links: PaginationLinks(selfLink: nil, first: nil, last: nil, next: nil, up: nil))
        )
        
        // System under test (SUT): repository with injected mocks.
        let repo = POIRepositoryImp(network: service, mapper: mapper)
        
        // Act - Then
        _ = try await repo.searchRadius(params: domainParams)
        
        // Assert - Expect
        // Verify mapping pipeline: repository must call mapper with the domain parameters.
        #expect(mapper.radiusCalled)
        #expect(mapper.capturedRadiusParams?.lat == 40.7)
        #expect(mapper.capturedRadiusParams?.lon == -73.9)
        #expect(mapper.capturedRadiusParams?.radius == 500)
        #expect(mapper.capturedRadiusParams?.categories?.count == 2)
    }
    
    /// Validates that `searchRadius(params:)` triggers exactly one network call
    /// and that the repository selects the correct endpoint case: `.searchRadius`.
    ///
    /// Assertions focus on:
    /// - Service invocation count
    /// - Endpoint case used
    /// - Correct values inside the endpoint parameters (latitude/longitude/radius)
    @Test("searchRadius should call network service with correct endpoint")
    func test_searchRadius_callsServiceWithCorrectEndpoint() async throws {
        
        // Arrange - given
        // Service captures endpoint; mapper provides the corresponding data params.
        let service = MockNetworkService()
        let mapper = MockPOIMapper()
        
        // Domain input for radius search.
        let domainParams = POIRadiusParametersDomainModel(
            lat: 10.0, lon: 20.0, radius: 100,
            categories: nil, limit: 5, offset: 0
        )
        
        // Expected mapped data parameters.
        mapper.expectedRadiusDataParams = POIRadiusParametersDataModel(
            latitude: 10.0, longitude: 20.0, radius: 100,
            categories: nil, limit: 5, offset: 0
        )
        
        // Service stub response: empty list.
        service.listResponse = POIListResponse(
            data: [],
            meta: Meta(count: 0, links: PaginationLinks(selfLink: nil, first: nil, last: nil, next: nil, up: nil))
        )
        
        let repo = POIRepositoryImp(network: service, mapper: mapper)
        
        // Act - Then
        _ = try await repo.searchRadius(params: domainParams)
        
        // Assert - Expect
        // Verify one call and validate the endpoint type and values.
        #expect(service.callCount == 1)
        
        guard let endpoint = service.lastEndpoint as? POIEndpoint,
              case let .searchRadius(params) = endpoint else {
            Issue.record("Expected POIEndpoint.searchRadius")
            return
        }
        
        #expect(params.latitude == 10.0)
        #expect(params.longitude == 20.0)
        #expect(params.radius == 100)
    }
    
    /// Validates that POIs returned by the service for `searchRadius`
    /// are mapped into domain models using the mapper.
    ///
    /// Assertions focus on:
    /// - Correct mapping count (one per POI)
    /// - Data models passed to the mapper (verified by ID)
    /// - Returned domain list count and ordering/IDs
    @Test("searchRadius should map all POIs from service response to domain")
    func test_searchRadius_mapsAllPOIsToDomain() async throws {
        
        // Arrange - given
        let service = MockNetworkService()
        let mapper = MockPOIMapper()
        
        let domainParams = POIRadiusParametersDomainModel(
            lat: 0.0, lon: 0.0, radius: 100,
            categories: nil, limit: 10, offset: 0
        )
        
        mapper.expectedRadiusDataParams = POIRadiusParametersDataModel(
            latitude: 0.0, longitude: 0.0, radius: 100,
            categories: nil, limit: 10, offset: 0
        )
        
        // Service stub response includes two POIs to validate mapping for multiple items.
        service.listResponse = POIListResponse(
            data: [
                POIDataModel(
                    id: "poi_1",
                    self: POISelfLink(href: "", methods: []),
                    type: "location",
                    subType: "POI",
                    name: "POI One",
                    geoCode: GeoCode(latitude: 1.0, longitude: 2.0),
                    category: "RESTAURANT",
                    rank: nil,
                    tags: nil
                ),
                POIDataModel(
                    id: "poi_2",
                    self: POISelfLink(href: "", methods: []),
                    type: "location",
                    subType: "POI",
                    name: "POI Two",
                    geoCode: GeoCode(latitude: 3.0, longitude: 4.0),
                    category: "SIGHTS",
                    rank: nil,
                    tags: nil
                )
            ],
            meta: Meta(count: 2, links: PaginationLinks(selfLink: nil, first: nil, last: nil, next: nil, up: nil))
        )
        
        // Mapper returns predetermined domain models to decouple test from mapping logic.
        mapper.nextDomainList = [
            POIDomainModel(id: "poi_1", name: "POI One", lat: 1.0, lon: 2.0, category: "RESTAURANT"),
            POIDomainModel(id: "poi_2", name: "POI Two", lat: 3.0, lon: 4.0, category: "SIGHTS")
        ]
        
        let repo = POIRepositoryImp(network: service, mapper: mapper)
        
        // Act - Then
        let result = try await repo.searchRadius(params: domainParams)
        
        // Assert - Expect
        #expect(mapper.verifyMappingCount(2))
        #expect(mapper.verifyDataModelWasMapped(withId: "poi_1"))
        #expect(mapper.verifyDataModelWasMapped(withId: "poi_2"))
        #expect(result.count == 2)
        #expect(result[0].id == "poi_1")
        #expect(result[1].id == "poi_2")
    }
    
    /// Validates that `searchRadius` returns an empty array when the service
    /// returns no POIs, and that the mapper is not asked to map any POIs.
    @Test("searchRadius should return empty array when service returns no POIs")
    func test_searchRadius_emptyResults() async throws {
        
        // Arrange - given
        let service = MockNetworkService()
        let mapper = MockPOIMapper()
        
        let domainParams = POIRadiusParametersDomainModel(
            lat: 0.0, lon: 0.0, radius: 100,
            categories: nil, limit: 10, offset: 0
        )
        
        mapper.expectedRadiusDataParams = POIRadiusParametersDataModel(
            latitude: 0.0, longitude: 0.0, radius: 100,
            categories: nil, limit: 10, offset: 0
        )
        
        service.listResponse = POIListResponse(
            data: [],
            meta: Meta(count: 0, links: PaginationLinks(selfLink: nil, first: nil, last: nil, next: nil, up: nil))
        )
        
        let repo = POIRepositoryImp(network: service, mapper: mapper)
        
        // Act - Then
        let result = try await repo.searchRadius(params: domainParams)
        
        // Assert - Expect
        #expect(result.isEmpty)
        #expect(mapper.verifyMappingCount(0))
    }
    
    // MARK: - SEARCH BOUNDING BOX TESTS
    // These tests validate the repository behavior for bounding-box searches,
    // ensuring correct mapping, endpoint selection, and response mapping.
    
    /// Validates that bounding-box domain parameters are converted into
    /// bounding-box data parameters via the mapper.
    @Test("searchBoundingBox should convert domain params to data params using mapper")
    func test_searchBoundingBox_convertsParamsCorrectly() async throws {
        
        // Arrange - given
        let service = MockNetworkService()
        let mapper = MockPOIMapper()
        
        let domainParams = POIBoundingBoxParametersDomainModel(
            north: 40.8, south: 40.7,
            east: -73.9, west: -74.0,
            categories: [.historical],
            limit: 15, offset: 0
        )
        
        mapper.expectedBoundingDataParams = POIBoundingBoxParametersDataModel(
            north: 40.8, south: 40.7,
            east: -73.9, west: -74.0,
            categories: [.historical],
            limit: 15, offset: 0
        )
        
        service.listResponse = POIListResponse(
            data: [],
            meta: Meta(count: 0, links: PaginationLinks(selfLink: nil, first: nil, last: nil, next: nil, up: nil))
        )
        
        let repo = POIRepositoryImp(network: service, mapper: mapper)
        
        // Act - Then
        _ = try await repo.searchBoundingBox(params: domainParams)
        
        // Assert - Expect
        #expect(mapper.boundingCalled)
        #expect(mapper.capturedBoundingParams?.north == 40.8)
        #expect(mapper.capturedBoundingParams?.south == 40.7)
        #expect(mapper.capturedBoundingParams?.east == -73.9)
        #expect(mapper.capturedBoundingParams?.west == -74.0)
    }
    
    /// Validates that `searchBoundingBox` selects `POIEndpoint.searchBoundingBox`
    /// and that the endpoint parameters match the expected mapped values.
    @Test("searchBoundingBox should call network service with correct endpoint")
    func test_searchBoundingBox_callsServiceWithCorrectEndpoint() async throws {
        
        // Arrange - given
        let service = MockNetworkService()
        let mapper = MockPOIMapper()
        
        let domainParams = POIBoundingBoxParametersDomainModel(
            north: 10.0, south: 5.0,
            east: 8.0, west: 3.0,
            categories: nil, limit: 10, offset: 0
        )
        
        mapper.expectedBoundingDataParams = POIBoundingBoxParametersDataModel(
            north: 10.0, south: 5.0,
            east: 8.0, west: 3.0,
            categories: nil, limit: 10, offset: 0
        )
        
        service.listResponse = POIListResponse(
            data: [],
            meta: Meta(count: 0, links: PaginationLinks(selfLink: nil, first: nil, last: nil, next: nil, up: nil))
        )
        
        let repo = POIRepositoryImp(network: service, mapper: mapper)
        
        // Act - Then
        _ = try await repo.searchBoundingBox(params: domainParams)
        
        // Assert - Expect
        #expect(service.callCount == 1)
        
        guard let endpoint = service.lastEndpoint as? POIEndpoint,
              case let .searchBoundingBox(params) = endpoint else {
            Issue.record("Expected POIEndpoint.searchBoundingBox")
            return
        }
        
        #expect(params.north == 10.0)
        #expect(params.south == 5.0)
        #expect(params.east == 8.0)
        #expect(params.west == 3.0)
    }
    
    /// Validates that POIs returned by the service for `searchBoundingBox`
    /// are mapped into domain models using the mapper.
    @Test("searchBoundingBox should map POIs from service response to domain")
    func test_searchBoundingBox_mapsPOIsToDomain() async throws {
        
        // Arrange - given
        let service = MockNetworkService()
        let mapper = MockPOIMapper()
        
        let domainParams = POIBoundingBoxParametersDomainModel(
            north: 10.0, south: 5.0, east: 8.0, west: 3.0,
            categories: nil, limit: 10, offset: 0
        )
        
        mapper.expectedBoundingDataParams = POIBoundingBoxParametersDataModel(
            north: 10.0, south: 5.0, east: 8.0, west: 3.0,
            categories: nil, limit: 10, offset: 0
        )
        
        service.listResponse = POIListResponse(
            data: [
                POIDataModel(
                    id: "bbox_1",
                    self: POISelfLink(href: "", methods: []),
                    type: "location",
                    subType: "POI",
                    name: "Box POI",
                    geoCode: GeoCode(latitude: 7.0, longitude: 6.0),
                    category: "HISTORICAL",
                    rank: nil,
                    tags: nil
                )
            ],
            meta: Meta(count: 1, links: PaginationLinks(selfLink: nil, first: nil, last: nil, next: nil, up: nil))
        )
        
        mapper.nextDomainList = [
            POIDomainModel(id: "bbox_1", name: "Box POI", lat: 7.0, lon: 6.0, category: "HISTORICAL")
        ]
        
        let repo = POIRepositoryImp(network: service, mapper: mapper)
        
        // Act - Then
        let result = try await repo.searchBoundingBox(params: domainParams)
        
        // Assert - Expect
        #expect(mapper.verifyMappingCount(1))
        #expect(mapper.verifyDataModelWasMapped(withId: "bbox_1"))
        #expect(result.count == 1)
        #expect(result[0].id == "bbox_1")
    }
    
    // MARK: - GET BY ID TESTS
    // These tests validate the repository behavior for retrieving a single POI by ID,
    // including endpoint selection and mapping into a domain model.
    
    /// Validates that `getById(_:)` uses the `.getById` endpoint and triggers one network call.
    @Test("getById should call network service with correct endpoint")
    func test_getById_callsServiceWithCorrectEndpoint() async throws {
        
        // Arrange - given
        let service = MockNetworkService()
        let mapper = MockPOIMapper()
        
        let poiId = "poi_123"
        
        service.singleResponse = POISingleResponse(
            data: POIDataModel(
                id: poiId,
                self: POISelfLink(href: "", methods: []),
                type: "location",
                subType: "POI",
                name: "Test POI",
                geoCode: GeoCode(latitude: 10.0, longitude: 20.0),
                category: "TEST",
                rank: nil,
                tags: nil
            )
        )
        
        mapper.nextDomainSingle = POIDomainModel(
            id: poiId,
            name: "Test POI",
            lat: 10.0,
            lon: 20.0,
            category: "TEST"
        )
        
        let repo = POIRepositoryImp(network: service, mapper: mapper)
        
        // Act - Then
        _ = try await repo.getById(poiId)
        
        // Assert - Expect
        #expect(service.callCount == 1)
        
        guard let endpoint = service.lastEndpoint as? POIEndpoint,
              case let .getById(id) = endpoint else {
            Issue.record("Expected POIEndpoint.getById")
            return
        }
        
        #expect(id == poiId)
    }
    
    /// Validates that `getById(_:)` maps a single POI data model into a domain model
    /// and returns the expected domain representation.
    @Test("getById should map single POI from service response to domain")
    func test_getById_mapsPOIToDomain() async throws {
        
        // Arrange - given
        let service = MockNetworkService()
        let mapper = MockPOIMapper()
        
        let poiId = "single_poi"
        
        service.singleResponse = POISingleResponse(
            data: POIDataModel(
                id: poiId,
                self: POISelfLink(href: "", methods: []),
                type: "location",
                subType: "POI",
                name: "Single POI",
                geoCode: GeoCode(latitude: 5.0, longitude: 6.0),
                category: "ATTRACTION",
                rank: 95,
                tags: ["popular"]
            )
        )
        
        mapper.nextDomainSingle = POIDomainModel(
            id: poiId,
            name: "Single POI",
            lat: 5.0,
            lon: 6.0,
            category: "ATTRACTION"
        )
        
        let repo = POIRepositoryImp(network: service, mapper: mapper)
        
        // Act - Then
        let result = try await repo.getById(poiId)
        
        // Assert - Expect
        #expect(mapper.verifyMappingCount(1))
        #expect(mapper.verifyDataModelWasMapped(withId: poiId))
        #expect(result.id == poiId)
        #expect(result.name == "Single POI")
    }
    
    // MARK: - ERROR PROPAGATION TESTS
    // These tests confirm that `POIRepositoryImp` does not swallow or transform errors
    // coming from the network/service layer; errors must be propagated unchanged.
    
    /// Validates that a timeout error thrown by the network service
    /// is propagated unchanged from `searchRadius`.
    @Test("searchRadius should propagate network timeout error")
    func test_searchRadius_propagatesTimeoutError() async {
        
        // Arrange - given
        let service = MockNetworkService()
        let mapper = MockPOIMapper()
        
        service.errorToThrow = NetworkingError.timeout
        
        mapper.expectedRadiusDataParams = POIRadiusParametersDataModel(
            latitude: 0, longitude: 0, radius: 100,
            categories: nil, limit: 10, offset: 0
        )
        
        let repo = POIRepositoryImp(network: service, mapper: mapper)
        
        let params = POIRadiusParametersDomainModel(
            lat: 0, lon: 0, radius: 100,
            categories: nil, limit: 10, offset: 0
        )
        
        // Assert - Expect
        await #expect {
            // Act - Then
            _ = try await repo.searchRadius(params: params)
        } throws: { error in
            guard let netError = error as? NetworkingError else { return false }
            return netError == .timeout
        }
    }
    
    /// Validates that a no-connection error thrown by the network service
    /// is propagated unchanged from `searchRadius`.
    @Test("searchRadius should propagate no connection error")
    func test_searchRadius_propagatesNoConnectionError() async {
        
        // Arrange - given
        let service = MockNetworkService()
        let mapper = MockPOIMapper()
        
        service.errorToThrow = NetworkingError.noConnection
        
        mapper.expectedRadiusDataParams = POIRadiusParametersDataModel(
            latitude: 0, longitude: 0, radius: 100,
            categories: nil, limit: 10, offset: 0
        )
        
        let repo = POIRepositoryImp(network: service, mapper: mapper)
        
        let params = POIRadiusParametersDomainModel(
            lat: 0, lon: 0, radius: 100,
            categories: nil, limit: 10, offset: 0
        )
        
        // Assert - Expect
        await #expect {
            // Act - Then
            _ = try await repo.searchRadius(params: params)
        } throws: { error in
            guard let netError = error as? NetworkingError else { return false }
            return netError == .noConnection
        }
    }
    
    /// Validates that a server error thrown by the network service
    /// is propagated unchanged from `searchBoundingBox`.
    @Test("searchBoundingBox should propagate server error")
    func test_searchBoundingBox_propagatesServerError() async {
        
        // Arrange - given
        let service = MockNetworkService()
        let mapper = MockPOIMapper()
        
        service.errorToThrow = NetworkingError.serverError(code: 500, message: "Internal Server Error")
        
        mapper.expectedBoundingDataParams = POIBoundingBoxParametersDataModel(
            north: 10, south: 5, east: 8, west: 3,
            categories: nil, limit: 10, offset: 0
        )
        
        let repo = POIRepositoryImp(network: service, mapper: mapper)
        
        let params = POIBoundingBoxParametersDomainModel(
            north: 10, south: 5, east: 8, west: 3,
            categories: nil, limit: 10, offset: 0
        )
        
        // Assert - Expect
        await #expect {
            // Act - Then
            _ = try await repo.searchBoundingBox(params: params)
        } throws: { error in
            guard let netError = error as? NetworkingError else { return false }
            if case .serverError(let code, _) = netError {
                return code == 500
            }
            return false
        }
    }
    
    /// Validates that a decoding error thrown by the network service
    /// is propagated unchanged from `searchBoundingBox`.
    @Test("searchBoundingBox should propagate decoding error")
    func test_searchBoundingBox_propagatesDecodingError() async {
        
        // Arrange - given
        let service = MockNetworkService()
        let mapper = MockPOIMapper()
        
        let decodingError = DecodingError.dataCorrupted(
            DecodingError.Context(codingPath: [], debugDescription: "Invalid JSON")
        )
        
        service.errorToThrow = NetworkingError.decodingFailed(decodingError)
        
        mapper.expectedBoundingDataParams = POIBoundingBoxParametersDataModel(
            north: 10, south: 5, east: 8, west: 3,
            categories: nil, limit: 10, offset: 0
        )
        
        let repo = POIRepositoryImp(network: service, mapper: mapper)
        
        let params = POIBoundingBoxParametersDomainModel(
            north: 10, south: 5, east: 8, west: 3,
            categories: nil, limit: 10, offset: 0
        )
        
        // Assert - Expect
        await #expect {
            // Act - Then
            _ = try await repo.searchBoundingBox(params: params)
        } throws: { error in
            guard let netError = error as? NetworkingError else { return false }
            if case .decodingFailed = netError {
                return true
            }
            return false
        }
    }
    
    /// Validates that `NetworkingError.emptyResponse` is propagated unchanged from `getById`.
    @Test("getById should propagate empty response error")
    func test_getById_propagatesEmptyResponseError() async {
        
        // Arrange - given
        let service = MockNetworkService()
        let mapper = MockPOIMapper()
        
        service.errorToThrow = NetworkingError.emptyResponse
        
        let repo = POIRepositoryImp(network: service, mapper: mapper)
        
        // Assert - Expect
        await #expect {
            // Act - Then
            _ = try await repo.getById("any_id")
        } throws: { error in
            guard let netError = error as? NetworkingError else { return false }
            return netError == .emptyResponse
        }
    }
    
    /// Validates that `NetworkingError.invalidContentType` is propagated unchanged from `getById`.
    @Test("getById should propagate invalid content type error")
    func test_getById_propagatesInvalidContentTypeError() async {
        
        // Arrange - given
        let service = MockNetworkService()
        let mapper = MockPOIMapper()
        
        service.errorToThrow = NetworkingError.invalidContentType
        
        let repo = POIRepositoryImp(network: service, mapper: mapper)
        
        // Assert - Expect
        await #expect {
            // Act - Then
            _ = try await repo.getById("any_id")
        } throws: { error in
            guard let netError = error as? NetworkingError else { return false }
            return netError == .invalidContentType
        }
    }
}
