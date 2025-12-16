//
//  MockPOIMapper.swift
//  TravelingTests
//
//  Created by Rodolfo Gonzalez on 16-12-25.
//

@testable import Traveling
import Foundation

final class MockPOIMapper: POIMapperProtocol {

    // MARK: - Call Tracking
    
    var radiusCalled = false
    var boundingCalled = false
    var dataToDomainCallCount = 0

    // MARK: - Expected Parameters
    
    var expectedRadiusDataParams: POIRadiusParametersDataModel?
    var expectedBoundingDataParams: POIBoundingBoxParametersDataModel?

    // MARK: - Mock Return Values
    
    var nextDomainList: [POIDomainModel] = []
    var nextDomainSingle: POIDomainModel?

    // MARK: - Captured Data (for verification)
    
    var capturedRadiusParams: POIRadiusParametersDomainModel?
    var capturedBoundingParams: POIBoundingBoxParametersDomainModel?
    var capturedDataModels: [POIDataModel] = []

    // MARK: - Protocol Implementation

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

        // Fallback: mapeo real
        return POIDomainModel(
            id: data.id,
            name: data.name,
            lat: data.geoCode.latitude,
            lon: data.geoCode.longitude,
            category: data.category
        )
    }
    
    // MARK: - Verification Helpers
    
    func verifyDataModelWasMapped(withId id: String) -> Bool {
        return capturedDataModels.contains { $0.id == id }
    }
    
    func verifyMappingCount(_ count: Int) -> Bool {
        return dataToDomainCallCount == count
    }
    
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


