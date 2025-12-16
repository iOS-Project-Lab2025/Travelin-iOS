//
//  MockRequestBuilder.swift
//  TravelingTests
//
//  Created by Rodolfo Gonzalez on 16-12-25.
//

@testable import Traveling
import Foundation

/// Mock implementation of `RequestBuilderProtocol` used for testing.
///
/// This mock allows tests to:
/// - Simulate request-building failures
/// - Return a predictable `URLRequest` without performing real logic
///
/// It is intentionally minimal to keep tests focused on
/// higher-level networking behavior.
final class MockRequestBuilder: RequestBuilderProtocol {

    /// Optional error to be thrown when building a request.
    ///
    /// When set, `buildRequest(from:body:)` will immediately throw
    /// this error instead of returning a request.
    var thrownError: Error?

    /// Builds a `URLRequest` for the given endpoint.
    ///
    /// - Parameters:
    ///   - endPoint: The endpoint definition used to build the request.
    ///   - body: Optional request body.
    /// - Returns: A valid `URLRequest` with a fixed test URL.
    /// - Throws: The predefined `thrownError`, if set.
    func buildRequest(
        from endPoint: EndPointProtocol,
        body: Encodable?
    ) throws -> URLRequest {
        if let error = thrownError { throw error }
        return URLRequest(url: URL(string: "https://api.test.com/ok")!)
    }
}
