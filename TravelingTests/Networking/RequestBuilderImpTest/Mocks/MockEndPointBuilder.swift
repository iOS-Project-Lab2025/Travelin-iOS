//
//  MockEndPointBuilder.swift
//  TravelingTests
//
//  Created by Rodolfo Gonzalez on 16-12-25.
//

import Foundation
@testable import Traveling

// MARK: - Mock EndPointBuilder

/// Mock implementation of `EndPointBuilderProtocol` used for unit testing.
///
/// This mock allows tests to:
/// - Capture the endpoint used to build a URL
/// - Return a predefined URL
/// - Simulate URL building failures by throwing errors
///
/// The implementation is intentionally minimal to ensure
/// tests focus on request-building behavior rather than URL composition logic.
final class MockEndPointBuilder: EndPointBuilderProtocol {

    /// URL to be returned when building the endpoint URL.
    var returnedURL: URL?

    /// Captures the endpoint passed to `buildURL(from:)`
    /// for later verification in tests.
    var capturedEndpoint: EndPointProtocol?

    /// Optional error to be thrown instead of returning a URL.
    var thrownError: Error?

    /// Simulates URL construction from an endpoint definition.
    ///
    /// - Parameter endPoint: The endpoint used to build the URL.
    /// - Returns: A `URL` representing the endpoint.
    /// - Throws: The predefined `thrownError`, if set.
    func buildURL(from endPoint: EndPointProtocol) throws -> URL {
        capturedEndpoint = endPoint
        if let error = thrownError { throw error }
        return returnedURL ?? URL(string: "https://example.com/default")!
    }
}
