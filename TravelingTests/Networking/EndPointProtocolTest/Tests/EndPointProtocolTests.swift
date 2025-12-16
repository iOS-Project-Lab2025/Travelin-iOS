//
//  EndPointProtocolTests.swift
//  TravelingTests
//
//  Created by Rodolfo Gonzalez on 16-12-25.
//

import Testing
@testable import Traveling
import Foundation

@Suite("EndPointProtocol Tests")
struct EndPointProtocolTests {

    // MARK: - Default Behavior

    @Test("Endpoints without custom query items expose nil queryItems")
    func defaultQueryItemsAreNil() {
        let endpoint = MockEndpoint()

        #expect(endpoint.queryItems == nil)
    }

    @Test("Endpoints without custom headers expose nil headers")
    func defaultHeadersAreNil() {
        let endpoint = MockEndpoint()

        #expect(endpoint.headers == nil)
    }

    // MARK: - Required Properties

    @Test("Endpoint exposes method and path")
    func exposesMethodAndPath() {
        let endpoint = MockEndpoint()

        #expect(endpoint.method == .get)
        #expect(endpoint.path == "/test")
    }

    // MARK: - URL Usability

    @Test("Endpoint can be used to construct a valid URL")
    func canBuildValidURL() {
        let endpoint = MockEndpoint()

        var components = URLComponents(string: "https://api.example.com")!
        components.path = endpoint.path
        components.queryItems = endpoint.queryItems

        #expect(components.url != nil)
    }

    // MARK: - Custom Overrides

    @Test("Endpoint can override query items")
    func allowsCustomQueryItems() {
        let endpoint = EndpointWithQueryItems()

        #expect(endpoint.queryItems != nil)
        #expect(endpoint.queryItems?.count == 1)
        #expect(endpoint.queryItems?.first?.name == "q")
    }

    @Test("Endpoint can override headers")
    func allowsCustomHeaders() {
        let endpoint = EndpointWithHeaders()

        #expect(endpoint.headers != nil)
        #expect(endpoint.headers?["Authorization"] == "Bearer token")
    }

    // MARK: - Helpers (Test-only)

    private struct MockEndpoint: EndPointProtocol {
        var method: HTTPMethod { .get }
        var path: String { "/test" }
    }

    private struct EndpointWithQueryItems: EndPointProtocol {
        var method: HTTPMethod { .get }
        var path: String { "/search" }
        var queryItems: [URLQueryItem]? {
            [URLQueryItem(name: "q", value: "coffee")]
        }
    }

    private struct EndpointWithHeaders: EndPointProtocol {
        var method: HTTPMethod { .get }
        var path: String { "/secure" }
        var headers: [String: String]? {
            ["Authorization": "Bearer token"]
        }
    }
}

