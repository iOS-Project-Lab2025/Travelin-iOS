//
//  MockNetworkService.swift
//  TravelingTests
//
//  Created by Rodolfo Gonzalez on 16-12-25.
//

@testable import Traveling
import Foundation

/// Mock simplificado enfocado solo en las responsabilidades del Repository
final class MockNetworkService: NetworkServiceProtocol {

    // MARK: - Captured Data
    
    var lastEndpoint: EndPointProtocol?
    var lastBody: Encodable?
    var callCount = 0

    // MARK: - Mock Responses
    
    var listResponse: POIListResponse?
    var singleResponse: POISingleResponse?
    var errorToThrow: Error?

    // MARK: - Protocol Implementation
    
    func execute<Response>(
        _ endpoint: any EndPointProtocol,
        responseType: Response.Type,
        body: Encodable?
    ) async throws -> Response where Response : Decodable {

        callCount += 1
        lastEndpoint = endpoint
        lastBody = body

        if let e = errorToThrow { throw e }

        if let list = listResponse as? Response {
            return list
        }

        if let single = singleResponse as? Response {
            return single
        }

        fatalError("MockNetworkService: no mock response configured for \(Response.self)")
    }
    
    // MARK: - Helpers
    
    func reset() {
        lastEndpoint = nil
        lastBody = nil
        callCount = 0
        listResponse = nil
        singleResponse = nil
        errorToThrow = nil
    }
}


