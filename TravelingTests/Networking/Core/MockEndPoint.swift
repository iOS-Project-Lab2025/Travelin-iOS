//
//  MockEndPoint.swift
//  TravelingTests
//
//  Created by Rodolfo Gonzalez on 15-12-25.
//

@testable import Traveling
import Foundation

/// Mock implementation of `EndPointProtocol` used for testing purposes.
///
/// This struct allows tests to define and control endpoint-related
/// configuration without relying on real networking logic.
///
/// It is typically used to:
/// - Inject custom HTTP methods
/// - Define endpoint paths
/// - Provide optional query items
/// - Provide optional HTTP headers
///
/// No behavior is implemented here; this type only serves as
/// a lightweight data holder for endpoint parameters in tests.
struct MockEndPoint: EndPointProtocol {

    /// HTTP method associated with the endpoint (e.g. GET, POST).
    var method: HTTPMethod

    /// Path component of the endpoint URL.
    var path: String

    /// Optional query parameters appended to the request URL.
    var queryItems: [URLQueryItem]?

    /// Optional HTTP headers to be included in the request.
    var headers: [String: String]?
}
