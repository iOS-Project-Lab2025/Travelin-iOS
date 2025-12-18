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
    
    @Test("searchRadius should convert domain params to data params using mapper")
    func test_searchRadius_convertsParamsCorrectly() async throws {
        
        // Arrange - given
        let service = MockNetworkService()
        let mapper = MockPOIMapper()
        
        let domainParams = POIRadiusParametersDomainModel(
            lat: 40.7,
            lon: -73.9,
            radius: 500,
            categories: [.restaurant, .sights],
            page: PageParameters(limit: 20),
            offset: 0
        )
        
        mapper.expectedRadiusDataParams = POIRadiusParametersDataModel(
            latitude: 40.7,
            longitude: -73.9,
            radius: 500,
            categories: [.restaurant, .sights],
            page: PageParameters(limit: 20),
            offset: 0
        )
        
        service.listResponse = POIListResponse(
            data: [],
            meta: Meta(count: 0, links: PaginationLinks(selfLink: nil, first: nil, last: nil, next: nil, up: nil))
        )
        
        let repo = POIRepositoryImp(network: service, mapper: mapper)
        
        // Act - Then
        _ = try await repo.searchRadius(params: domainParams)
        
        // Assert - Expect
        #expect(mapper.radiusCalled)
        #expect(mapper.capturedRadiusParams?.lat == 40.7)
        #expect(mapper.capturedRadiusParams?.lon == -73.9)
        #expect(mapper.capturedRadiusParams?.radius == 500)
        #expect(mapper.capturedRadiusParams?.categories?.count == 2)
    }
    
    @Test("searchRadius should call network service with correct endpoint")
    func test_searchRadius_callsServiceWithCorrectEndpoint() async throws {
        
        // Arrange - given
        let service = MockNetworkService()
        let mapper = MockPOIMapper()
        
        let domainParams = POIRadiusParametersDomainModel(
            lat: 10.0, lon: 20.0, radius: 100,
            categories: nil, page: PageParameters(limit: 5), offset: 0
        )
        
        mapper.expectedRadiusDataParams = POIRadiusParametersDataModel(
            latitude: 10.0, longitude: 20.0, radius: 100,
            categories: nil, page: PageParameters(limit: 5), offset: 0
        )
        
        service.listResponse = POIListResponse(
            data: [],
            meta: Meta(count: 0, links: PaginationLinks(selfLink: nil, first: nil, last: nil, next: nil, up: nil))
        )
        
        let repo = POIRepositoryImp(network: service, mapper: mapper)
        
        // Act - Then
        _ = try await repo.searchRadius(params: domainParams)
        
        // Assert - Expect
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
    
    @Test("searchRadius should map all POIs from service response to domain")
    func test_searchRadius_mapsAllPOIsToDomain() async throws {
        
        // Arrange - given
        let service = MockNetworkService()
        let mapper = MockPOIMapper()
        
        let domainParams = POIRadiusParametersDomainModel(
            lat: 0.0, lon: 0.0, radius: 100,
            categories: nil, page: PageParameters(limit: 10), offset: 0
        )
        
        mapper.expectedRadiusDataParams = POIRadiusParametersDataModel(
            latitude: 0.0, longitude: 0.0, radius: 100,
            categories: nil, page: PageParameters(limit: 10), offset: 0
        )
        
        service.listResponse = POIListResponse(
            data: [
                POIDataModel(
                    id: "poi_1",
                    self: POISelfLink(href: "", methods: []),
                    type: "location",
                    pictures: [],
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
                    pictures: [],
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
        
        mapper.nextDomainList = [
            POIDomainModel(id: "poi_1", name: "POI One", pictures: [],lat: 1.0, lon: 2.0, category: "RESTAURANT"),
            POIDomainModel(id: "poi_2", name: "POI Two", pictures: [], lat: 3.0, lon: 4.0, category: "SIGHTS")
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
    
    @Test("searchRadius should return empty array when service returns no POIs")
    func test_searchRadius_emptyResults() async throws {
        
        // Arrange - given
        let service = MockNetworkService()
        let mapper = MockPOIMapper()
        
        let domainParams = POIRadiusParametersDomainModel(
            lat: 0.0, lon: 0.0, radius: 100,
            categories: nil, page: PageParameters(limit: 10), offset: 0
        )
        
        mapper.expectedRadiusDataParams = POIRadiusParametersDataModel(
            latitude: 0.0, longitude: 0.0, radius: 100,
            categories: nil, page: PageParameters(limit: 10), offset: 0
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
    
    @Test("searchBoundingBox should convert domain params to data params using mapper")
    func test_searchBoundingBox_convertsParamsCorrectly() async throws {
        
        // Arrange - given
        let service = MockNetworkService()
        let mapper = MockPOIMapper()
        
        let domainParams = POIBoundingBoxParametersDomainModel(
            north: 40.8, south: 40.7,
            east: -73.9, west: -74.0,
            categories: [.historical],
            page: PageParameters(limit: 15), offset: 0
        )
        
        mapper.expectedBoundingDataParams = POIBoundingBoxParametersDataModel(
            north: 40.8, south: 40.7,
            east: -73.9, west: -74.0,
            categories: [.historical],
            page: PageParameters(limit: 15), offset: 0
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
    
    @Test("searchBoundingBox should call network service with correct endpoint")
    func test_searchBoundingBox_callsServiceWithCorrectEndpoint() async throws {
        
        // Arrange - given
        let service = MockNetworkService()
        let mapper = MockPOIMapper()
        
        let domainParams = POIBoundingBoxParametersDomainModel(
            north: 10.0, south: 5.0,
            east: 8.0, west: 3.0,
            categories: nil, page: PageParameters(limit: 10), offset: 0
        )
        
        mapper.expectedBoundingDataParams = POIBoundingBoxParametersDataModel(
            north: 10.0, south: 5.0,
            east: 8.0, west: 3.0,
            categories: nil, page: PageParameters(limit: 10), offset: 0
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
    
    @Test("searchBoundingBox should map POIs from service response to domain")
    func test_searchBoundingBox_mapsPOIsToDomain() async throws {
        
        // Arrange - given
        let service = MockNetworkService()
        let mapper = MockPOIMapper()
        
        let domainParams = POIBoundingBoxParametersDomainModel(
            north: 10.0, south: 5.0, east: 8.0, west: 3.0,
            categories: nil, page: PageParameters(limit: 10), offset: 0
        )
        
        mapper.expectedBoundingDataParams = POIBoundingBoxParametersDataModel(
            north: 10.0, south: 5.0, east: 8.0, west: 3.0,
            categories: nil, page: PageParameters(limit: 10), offset: 0
        )
        
        service.listResponse = POIListResponse(
            data: [
                POIDataModel(
                    id: "bbox_1",
                    self: POISelfLink(href: "", methods: []),
                    type: "location",
                    pictures: [],
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
            POIDomainModel(id: "bbox_1", name: "Box POI", pictures: [], lat: 7.0, lon: 6.0, category: "HISTORICAL")
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
                pictures: [],
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
            pictures: [],
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
                pictures: [],
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
            pictures: [],
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
    
    @Test("searchRadius should propagate network timeout error")
    func test_searchRadius_propagatesTimeoutError() async {
        
        // Arrange - given
        let service = MockNetworkService()
        let mapper = MockPOIMapper()
        
        service.errorToThrow = NetworkingError.timeout
        
        mapper.expectedRadiusDataParams = POIRadiusParametersDataModel(
            latitude: 0, longitude: 0, radius: 100,
            categories: nil, page: PageParameters(limit: 10), offset: 0
        )
        
        let repo = POIRepositoryImp(network: service, mapper: mapper)
        
        let params = POIRadiusParametersDomainModel(
            lat: 0, lon: 0, radius: 100,
            categories: nil, page: PageParameters(limit: 10), offset: 0
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
    
    @Test("searchRadius should propagate no connection error")
    func test_searchRadius_propagatesNoConnectionError() async {
        
        // Arrange - given
        let service = MockNetworkService()
        let mapper = MockPOIMapper()
        
        service.errorToThrow = NetworkingError.noConnection
        
        mapper.expectedRadiusDataParams = POIRadiusParametersDataModel(
            latitude: 0, longitude: 0, radius: 100,
            categories: nil, page: PageParameters(limit: 10), offset: 0
        )
        
        let repo = POIRepositoryImp(network: service, mapper: mapper)
        
        let params = POIRadiusParametersDomainModel(
            lat: 0, lon: 0, radius: 100,
            categories: nil, page: PageParameters(limit: 10), offset: 0
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
    
    @Test("searchBoundingBox should propagate server error")
    func test_searchBoundingBox_propagatesServerError() async {
        
        // Arrange - given
        let service = MockNetworkService()
        let mapper = MockPOIMapper()
        
        service.errorToThrow = NetworkingError.serverError(code: 500, message: "Internal Server Error")
        
        mapper.expectedBoundingDataParams = POIBoundingBoxParametersDataModel(
            north: 10, south: 5, east: 8, west: 3,
            categories: nil, page: PageParameters(limit: 10), offset: 0
        )
        
        let repo = POIRepositoryImp(network: service, mapper: mapper)
        
        let params = POIBoundingBoxParametersDomainModel(
            north: 10, south: 5, east: 8, west: 3,
            categories: nil, page: PageParameters(limit: 10), offset: 0
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
            categories: nil, page: PageParameters(limit: 10), offset: 0
        )
        
        let repo = POIRepositoryImp(network: service, mapper: mapper)
        
        let params = POIBoundingBoxParametersDomainModel(
            north: 10, south: 5, east: 8, west: 3,
            categories: nil, page: PageParameters(limit: 10), offset: 0
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
    
    //ADD
    // MARK: - SEARCH BY NAME TESTS

    @Test("searchByName should convert domain params to data params using mapper")
    func test_searchByName_convertsParamsCorrectly() async throws {

        // Arrange - given
        let service = MockNetworkService()
        let mapper = MockPOIMapper()

        let domainParams = POIGetByNameParametersDomainModel(
            name: "Museum",
            categories: [.sights, .historical]
        )

        mapper.expectedGetByNameDataParams = POIGetByNameParametersDataModel(
            name: "Museum",
            categories: [.sights, .historical]
        )

        service.listResponse = POIListResponse(
            data: [],
            meta: Meta(count: 0, links: PaginationLinks(selfLink: nil, first: nil, last: nil, next: nil, up: nil))
        )

        let repo = POIRepositoryImp(network: service, mapper: mapper)

        // Act - Then
        _ = try await repo.searchByName(params: domainParams)

        // Assert - Expect
        #expect(mapper.getByNameCalled)
        #expect(mapper.capturedGetByNameParams?.name == "Museum")
        #expect(mapper.capturedGetByNameParams?.categories?.count == 2)
    }

    @Test("searchByName should call network service with correct endpoint")
    func test_searchByName_callsServiceWithCorrectEndpoint() async throws {

        // Arrange - given
        let service = MockNetworkService()
        let mapper = MockPOIMapper()

        let domainParams = POIGetByNameParametersDomainModel(
            name: "Cafe",
            categories: nil
        )

        mapper.expectedGetByNameDataParams = POIGetByNameParametersDataModel(
            name: "Cafe",
            categories: nil
        )

        service.listResponse = POIListResponse(
            data: [],
            meta: Meta(count: 0, links: PaginationLinks(selfLink: nil, first: nil, last: nil, next: nil, up: nil))
        )

        let repo = POIRepositoryImp(network: service, mapper: mapper)

        // Act - Then
        _ = try await repo.searchByName(params: domainParams)

        // Assert - Expect
        #expect(service.callCount == 1)

        guard let endpoint = service.lastEndpoint as? POIEndpoint,
              case let .getByName(params) = endpoint else {
            Issue.record("Expected POIEndpoint.getByName")
            return
        }

        #expect(params.name == "Cafe")
        #expect(params.categories == nil)
    }

    @Test("searchByName should map all POIs from service response to domain")
    func test_searchByName_mapsAllPOIsToDomain() async throws {

        // Arrange - given
        let service = MockNetworkService()
        let mapper = MockPOIMapper()

        let domainParams = POIGetByNameParametersDomainModel(
            name: "Park",
            categories: nil
        )

        mapper.expectedGetByNameDataParams = POIGetByNameParametersDataModel(
            name: "Park",
            categories: nil
        )

        service.listResponse = POIListResponse(
            data: [
                POIDataModel(
                    id: "name_1",
                    self: POISelfLink(href: "", methods: []),
                    type: "location",
                    pictures: [],
                    subType: "POI",
                    name: "Central Park",
                    geoCode: GeoCode(latitude: 1.0, longitude: 2.0),
                    category: "PARK",
                    rank: nil,
                    tags: nil
                ),
                POIDataModel(
                    id: "name_2",
                    self: POISelfLink(href: "", methods: []),
                    type: "location",
                    pictures: [],
                    subType: "POI",
                    name: "City Park",
                    geoCode: GeoCode(latitude: 3.0, longitude: 4.0),
                    category: "PARK",
                    rank: nil,
                    tags: nil
                )
            ],
            meta: Meta(count: 2, links: PaginationLinks(selfLink: nil, first: nil, last: nil, next: nil, up: nil))
        )

        mapper.nextDomainList = [
            POIDomainModel(id: "name_1", name: "Central Park", pictures: [], lat: 1.0, lon: 2.0, category: "PARK"),
            POIDomainModel(id: "name_2", name: "City Park", pictures: [], lat: 3.0, lon: 4.0, category: "PARK")
        ]

        let repo = POIRepositoryImp(network: service, mapper: mapper)

        // Act - Then
        let result = try await repo.searchByName(params: domainParams)

        // Assert - Expect
        #expect(mapper.verifyMappingCount(2))
        #expect(mapper.verifyDataModelWasMapped(withId: "name_1"))
        #expect(mapper.verifyDataModelWasMapped(withId: "name_2"))
        #expect(result.count == 2)
    }

    @Test("searchByName should return empty array when service returns no POIs")
    func test_searchByName_emptyResults() async throws {

        // Arrange - given
        let service = MockNetworkService()
        let mapper = MockPOIMapper()

        let domainParams = POIGetByNameParametersDomainModel(
            name: "Unknown",
            categories: nil
        )

        mapper.expectedGetByNameDataParams = POIGetByNameParametersDataModel(
            name: "Unknown",
            categories: nil
        )

        service.listResponse = POIListResponse(
            data: [],
            meta: Meta(count: 0, links: PaginationLinks(selfLink: nil, first: nil, last: nil, next: nil, up: nil))
        )

        let repo = POIRepositoryImp(network: service, mapper: mapper)

        // Act - Then
        let result = try await repo.searchByName(params: domainParams)

        // Assert - Expect
        #expect(result.isEmpty)
        #expect(mapper.verifyMappingCount(0))
    }

    @Test("searchByName should propagate network error")
    func test_searchByName_propagatesNetworkError() async {

        // Arrange - given
        let service = MockNetworkService()
        let mapper = MockPOIMapper()

        service.errorToThrow = NetworkingError.timeout

        mapper.expectedGetByNameDataParams = POIGetByNameParametersDataModel(
            name: "Museum",
            categories: nil
        )

        let repo = POIRepositoryImp(network: service, mapper: mapper)

        let params = POIGetByNameParametersDomainModel(
            name: "Museum",
            categories: nil
        )

        // Assert - Expect
        await #expect {
            // Act - Then
            _ = try await repo.searchByName(params: params)
        } throws: { error in
            guard let netError = error as? NetworkingError else { return false }
            return netError == .timeout
        }
    }

}
