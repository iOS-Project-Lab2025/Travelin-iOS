//
//  EndPointProtocolTests.swift
//  TravelingTests
//
//  Created by Rodolfo Gonzalez on 16-12-25.
//

import Testing
@testable import Traveling
import Foundation

/// Test suite for validating the default behavior and contract
/// of types conforming to `EndPointProtocol`.
///
/// These tests ensure that:
/// - Default protocol properties behave as expected
/// - Required properties are always exposed
/// - Endpoints can be safely used to construct URLs
/// - Conforming types can override optional properties
@Suite("EndPointProtocol Tests")
struct EndPointProtocolTests {

    // MARK: - Default Behavior

    /// Verifies that endpoints which do not provide custom
    /// query items expose `nil` as the default value.
    @Test("Endpoints without custom query items expose nil queryItems")
    func defaultQueryItemsAreNil() {
        let endpoint = MockEndpoint()

        #expect(endpoint.queryItems == nil)
    }

    /// Verifies that endpoints which do not provide custom
    /// headers expose `nil` as the default value.
    @Test("Endpoints without custom headers expose nil headers")
    func defaultHeadersAreNil() {
        let endpoint = MockEndpoint()

        #expect(endpoint.headers == nil)
    }

    // MARK: - Required Properties

    /// Verifies that an endpoint exposes the required
    /// `method` and `path` properties defined by the protocol.
    @Test("Endpoint exposes method and path")
    func exposesMethodAndPath() {
        let endpoint = MockEndpoint()

        #expect(endpoint.method == .get)
        #expect(endpoint.path == "/test")
    }

    // MARK: - URL Usability

    /// Verifies that an endpoint can be used to construct
    /// a valid `URL` when combined with URL components.
    ///
    /// This test ensures that the protocol requirements
    /// are sufficient for URL construction.
    @Test("Endpoint can be used to construct a valid URL")
    func canBuildValidURL() {
        let endpoint = MockEndpoint()

        var components = URLComponents(string: "https://api.example.com")!
        components.path = endpoint.path
        components.queryItems = endpoint.queryItems

        #expect(components.url != nil)
    }

    // MARK: - Custom Overrides

    /// Verifies that conforming types can override
    /// the default `queryItems` property.
    @Test("Endpoint can override query items")
    func allowsCustomQueryItems() {
        let endpoint = EndpointWithQueryItems()

        #expect(endpoint.queryItems != nil)
        #expect(endpoint.queryItems?.count == 1)
        #expect(endpoint.queryItems?.first?.name == "q")
    }

    /// Verifies that conforming types can override
    /// the default `headers` property.
    @Test("Endpoint can override headers")
    func allowsCustomHeaders() {
        let endpoint = EndpointWithHeaders()

        #expect(endpoint.headers != nil)
        #expect(endpoint.headers?["Authorization"] == "Bearer token")
    }

    // MARK: - Helpers (Test-only)

    /// Minimal endpoint implementation used to validate
    /// default protocol behavior.
    private struct MockEndpoint: EndPointProtocol {
        var method: HTTPMethod { .get }
        var path: String { "/test" }
    }

    /// Endpoint implementation that overrides `queryItems`
    /// to validate custom query parameter support.
    private struct EndpointWithQueryItems: EndPointProtocol {
        var method: HTTPMethod { .get }
        var path: String { "/search" }
        var queryItems: [URLQueryItem]? {
            [URLQueryItem(name: "q", value: "coffee")]
        }
    }

    /// Endpoint implementation that overrides `headers`
    /// to validate custom HTTP header support.
    private struct EndpointWithHeaders: EndPointProtocol {
        var method: HTTPMethod { .get }
        var path: String { "/secure" }
        var headers: [String: String]? {
            ["Authorization": "Bearer token"]
        }
    }
}
