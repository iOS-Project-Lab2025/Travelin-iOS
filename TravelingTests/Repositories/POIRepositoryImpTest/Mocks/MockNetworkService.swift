//
//  MockNetworkService.swift
//  TravelingTests
//
//  Created by Rodolfo Gonzalez on 16-12-25.
//

@testable import Traveling
import Foundation

/// Mock implementation of `NetworkServiceProtocol` focused on repository testing.
///
/// This mock is intentionally simplified to cover only the responsibilities
/// required by repository-level tests.
///
/// It allows tests to:
/// - Capture the last executed endpoint and request body
/// - Control the number of calls performed
/// - Return predefined list or single responses
/// - Simulate error scenarios by throwing predefined errors
final class MockNetworkService: NetworkServiceProtocol {

    // MARK: - Captured Data
    
    /// Captures the last endpoint passed to `execute`.
    var lastEndpoint: EndPointProtocol?
    
    /// Captures the request body passed to `execute`, if any.
    var lastBody: Encodable?
    
    /// Tracks how many times `execute` was called.
    var callCount = 0

    // MARK: - Mock Responses
    
    /// Mock response used when a list response is expected.
    var listResponse: POIListResponse?
    
    /// Mock response used when a single response is expected.
    var singleResponse: POISingleResponse?
    
    /// Optional error to be thrown instead of returning a response.
    var errorToThrow: Error?

    // MARK: - Protocol Implementation
    
    /// Simulates execution of a network request.
    ///
    /// - Parameters:
    ///   - endpoint: The endpoint describing the request.
    ///   - responseType: The expected response type.
    ///   - body: Optional request body.
    /// - Returns: A decoded response matching the expected type.
    /// - Throws: The predefined `errorToThrow`, if set.
    ///
    /// If no suitable mock response is configured for the expected
    /// response type, the method triggers a fatal error to highlight
    /// incorrect test setup.
    func execute<Response>(
        _ endpoint: any EndPointProtocol,
        responseType: Response.Type,
        body: Encodable?
    ) async throws -> Response where Response: Decodable {

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
    
    /// Resets all captured data and configured mock responses.
    ///
    /// This method is useful when reusing the mock across
    /// multiple test cases.
    func reset() {
        lastEndpoint = nil
        lastBody = nil
        callCount = 0
        listResponse = nil
        singleResponse = nil
        errorToThrow = nil
    }
}
