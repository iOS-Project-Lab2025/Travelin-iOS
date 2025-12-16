//
//  MockPOIMapper.swift
//  TravelingTests
//
//  Created by Rodolfo Gonzalez on 16-12-25.
//

@testable import Traveling
import Foundation

/// Mock implementation of `POIMapperProtocol` used for repository testing.
///
/// This mock allows tests to:
/// - Verify that mapping methods are invoked
/// - Capture domain models passed for mapping
/// - Return predefined data and domain models
/// - Track how many data-to-domain mappings are performed
///
/// It is designed to give full control over mapper behavior
/// without relying on real mapping logic.
final class MockPOIMapper: POIMapperProtocol {

    // MARK: - Call Tracking
    
    /// Indicates whether the radius mapping method was called.
    var radiusCalled = false
    
    /// Indicates whether the bounding-box mapping method was called.
    var boundingCalled = false
    
    /// Tracks how many times data-to-domain mapping was performed.
    var dataToDomainCallCount = 0

    // MARK: - Expected Parameters
    
    /// Expected data parameters returned when mapping radius domain parameters.
    var expectedRadiusDataParams: POIRadiusParametersDataModel?
    
    /// Expected data parameters returned when mapping bounding-box domain parameters.
    var expectedBoundingDataParams: POIBoundingBoxParametersDataModel?

    // MARK: - Mock Return Values
    
    /// Queue of domain models to be returned when mapping multiple data models.
    var nextDomainList: [POIDomainModel] = []
    
    /// Domain model to be returned when mapping a single data model.
    var nextDomainSingle: POIDomainModel?

    // MARK: - Captured Data (for verification)
    
    /// Captures the radius domain parameters passed to the mapper.
    var capturedRadiusParams: POIRadiusParametersDomainModel?
    
    /// Captures the bounding-box domain parameters passed to the mapper.
    var capturedBoundingParams: POIBoundingBoxParametersDomainModel?
    
    /// Captures all data models passed to `poiDataToDomain`.
    var capturedDataModels: [POIDataModel] = []

    // MARK: - Protocol Implementation

    /// Maps radius-based domain parameters into data parameters.
    ///
    /// This method records the invocation and returns a predefined
    /// data model configured by the test.
    func poiRadiusDomainToData(from model: POIRadiusParametersDomainModel)
        -> POIRadiusParametersDataModel
    {
        radiusCalled = true
        capturedRadiusParams = model
        
        guard let expected = expectedRadiusDataParams else {
            fatalError("MockPOIMapper: expectedRadiusDataParams not configured")
        }
        
        return expected
    }

    /// Maps bounding-box domain parameters into data parameters.
    ///
    /// This method records the invocation and returns a predefined
    /// data model configured by the test.
    func poiBoundingDomainToData(from model: POIBoundingBoxParametersDomainModel)
        -> POIBoundingBoxParametersDataModel
    {
        boundingCalled = true
        capturedBoundingParams = model
        
        guard let expected = expectedBoundingDataParams else {
            fatalError("MockPOIMapper: expectedBoundingDataParams not configured")
        }
        
        return expected
    }

    /// Maps a POI data model into a domain model.
    ///
    /// The returned value follows this priority:
    /// 1. The first element of `nextDomainList`, if available
    /// 2. `nextDomainSingle`, if configured
    /// 3. A fallback mapping using the data model values
    func poiDataToDomain(from data: POIDataModel) -> POIDomainModel
    {
        dataToDomainCallCount += 1
        capturedDataModels.append(data)

        if !nextDomainList.isEmpty {
            return nextDomainList.removeFirst()
        }

        if let single = nextDomainSingle {
            return single
        }

        // Fallback mapping using real data values
        return POIDomainModel(
            id: data.id,
            name: data.name,
            lat: data.geoCode.latitude,
            lon: data.geoCode.longitude,
            category: data.category
        )
    }
    
    // MARK: - Verification Helpers
    
    /// Verifies that a data model with the given identifier
    /// was passed to the mapper.
    func verifyDataModelWasMapped(withId id: String) -> Bool {
        return capturedDataModels.contains { $0.id == id }
    }
    
    /// Verifies that the data-to-domain mapping method
    /// was called the expected number of times.
    func verifyMappingCount(_ count: Int) -> Bool {
        return dataToDomainCallCount == count
    }
    
    /// Resets all captured data and configuration.
    ///
    /// This method is useful when reusing the mock
    /// across multiple test cases.
    func reset() {
        radiusCalled = false
        boundingCalled = false
        dataToDomainCallCount = 0
        capturedRadiusParams = nil
        capturedBoundingParams = nil
        capturedDataModels.removeAll()
        nextDomainList.removeAll()
        nextDomainSingle = nil
        expectedRadiusDataParams = nil
        expectedBoundingDataParams = nil
    }
}
