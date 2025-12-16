//
//  RequestBuilderImpTests.swift
//  TravelingTests
//
//  Created by Rodolfo Gonzalez on 16-12-25.
//

import Testing
import Foundation
@testable import Traveling

/// Test suite for validating the behavior of `RequestBuilderImp`.
///
/// These tests ensure that:
/// - URLs are built using `EndPointBuilder`
/// - HTTP methods are correctly applied
/// - Headers are merged with correct precedence
/// - Timeouts are consistently configured
/// - Request bodies are encoded and attached correctly
/// - Errors from dependencies are propagated as expected
@Suite("RequestBuilderImp Tests")
struct RequestBuilderImpTests {

    // MARK: - Build Request Tests

    /// Verifies that `buildRequest(from:)` delegates URL creation
    /// to `EndPointBuilder` and assigns the returned URL to the request.
    @Test("buildRequest should call EndPointBuilder and assign returned URL")
    func testRequestBuilder_buildRequest_assignsCorrectURL() throws {
        // Arrange
        let mockEndPointBuilder = MockEndPointBuilder()
        mockEndPointBuilder.returnedURL = URL(string: "https://test.com/user")!
        
        let builder = RequestBuilderImp(endPointBuilder: mockEndPointBuilder)
        let endpoint = MockEndPoint(method: .get, path: "/user")

        // Act
        let request = try builder.buildRequest(from: endpoint)

        // Assert
        #expect(request.url?.absoluteString == "https://test.com/user")
        #expect(mockEndPointBuilder.capturedEndpoint?.path == "/user")
    }

    /// Verifies that the HTTP method of the request
    /// matches the method defined by the endpoint.
    @Test("buildRequest should apply correct HTTP method")
    func testRequestBuilder_buildRequest_setsHTTPMethod() throws {
        // Arrange
        let mockEndPointBuilder = MockEndPointBuilder()
        mockEndPointBuilder.returnedURL = URL(string: "https://example.com")!
        
        let builder = RequestBuilderImp(endPointBuilder: mockEndPointBuilder)
        let endpoint = MockEndPoint(method: .post, path: "/login")

        // Act
        let request = try builder.buildRequest(from: endpoint)

        // Assert
        #expect(request.httpMethod == "POST")
    }

    /// Verifies that common headers and endpoint-specific headers
    /// are merged correctly, with endpoint headers taking precedence.
    @Test("buildRequest should merge common and endpoint headers with correct precedence")
    func testRequestBuilder_buildRequest_mergesHeadersCorrectly() throws {
        // Arrange
        let mockEndPointBuilder = MockEndPointBuilder()
        mockEndPointBuilder.returnedURL = URL(string: "https://example.com")!
        
        let builder = RequestBuilderImp(endPointBuilder: mockEndPointBuilder)
        let endpoint = MockEndPoint(
            method: .get,
            path: "/",
            headers: [
                "Accept": "image/png",  // Overrides common header
                "Custom": "XYZ"
            ]
        )

        // Act
        let request = try builder.buildRequest(from: endpoint)

        // Assert
        let headers = request.allHTTPHeaderFields!
        #expect(headers["Accept"] == "image/png")
        #expect(headers["Custom"] == "XYZ")
        #expect(headers["App-Version"] == "1.0")
    }

    /// Verifies that all requests created by the builder
    /// have a timeout interval of 30 seconds.
    @Test("buildRequest should always set 30s timeout")
    func testRequestBuilder_buildRequest_setsTimeout() throws {
        // Arrange
        let mockEndPointBuilder = MockEndPointBuilder()
        mockEndPointBuilder.returnedURL = URL(string: "https://example.com")!
        
        let builder = RequestBuilderImp(endPointBuilder: mockEndPointBuilder)
        let endpoint = MockEndPoint(method: .get, path: "/timeout")

        // Act
        let request = try builder.buildRequest(from: endpoint)

        // Assert
        #expect(request.timeoutInterval == 30)
    }

    /// Verifies that an encodable body is passed to `PayloadBuilder`,
    /// encoded, and attached to the request as HTTP body data.
    @Test("buildRequest should attach encoded body using PayloadBuilder")
    func testRequestBuilder_buildRequest_attachesBody() throws {
        // Arrange
        let mockEndPointBuilder = MockEndPointBuilder()
        mockEndPointBuilder.returnedURL = URL(string: "https://example.com")!
        
        let mockPayloadBuilder = MockPayloadBuilder()
        mockPayloadBuilder.returnedData = Data([1, 2, 3])
        
        let builder = RequestBuilderImp(
            endPointBuilder: mockEndPointBuilder,
            payloadBuilder: mockPayloadBuilder
        )
        
        struct Body: Encodable { let name: String }
        let endpoint = MockEndPoint(method: .post, path: "/create")

        // Act
        let request = try builder.buildRequest(from: endpoint, body: Body(name: "John"))

        // Assert
        #expect(request.httpBody == Data([1, 2, 3]))
        #expect(mockPayloadBuilder.capturedModel is Body)
    }

    // MARK: - Error Handling Tests

    /// Verifies that URL building errors thrown by `EndPointBuilder`
    /// are propagated without modification.
    @Test("buildRequest should propagate URL building error from EndPointBuilder")
    func testRequestBuilder_buildRequest_propagatesURLError() {
        // Arrange
        let mockEndPointBuilder = MockEndPointBuilder()
        mockEndPointBuilder.thrownError = NetworkingError.invalidURL(URLError(.badURL))
        
        let builder = RequestBuilderImp(endPointBuilder: mockEndPointBuilder)
        let endpoint = MockEndPoint(method: .get, path: "/bad")

        // Assert
        #expect {
            // Act
            _ = try builder.buildRequest(from: endpoint)
        } throws: { error in
            guard case NetworkingError.invalidURL = error else {
                return false
            }
            return true
        }
    }

    /// Verifies that attempting to attach a request body
    /// without a `PayloadBuilder` results in a `requestBuildingFailed` error.
    @Test("buildRequest should throw requestBuildingFailed when body exists but PayloadBuilder is nil")
    func testRequestBuilder_buildRequest_throwsMissingPayloadBuilder() {
        // Arrange
        let mockEndPointBuilder = MockEndPointBuilder()
        mockEndPointBuilder.returnedURL = URL(string: "https://example.com")!
        
        let builder = RequestBuilderImp(endPointBuilder: mockEndPointBuilder)
        
        struct Body: Encodable { let id: Int }
        let endpoint = MockEndPoint(method: .post, path: "/create")

        // Assert
        #expect {
            // Act
            _ = try builder.buildRequest(from: endpoint, body: Body(id: 1))
        } throws: { error in
            guard case NetworkingError.requestBuildingFailed = error else {
                return false
            }
            return true
        }
    }

    /// Verifies that encoding errors thrown by `PayloadBuilder`
    /// are propagated without modification.
    @Test("buildRequest should propagate encoding errors from PayloadBuilder")
    func testRequestBuilder_buildRequest_propagatesEncodingError() {
        // Arrange
        let mockEndPointBuilder = MockEndPointBuilder()
        mockEndPointBuilder.returnedURL = URL(string: "https://example.com")!
        
        let mockPayloadBuilder = MockPayloadBuilder()
        mockPayloadBuilder.thrownError = NetworkingError.encodingFailed(
            EncodingError.invalidValue("X", .init(codingPath: [], debugDescription: "invalid"))
        )
        
        let builder = RequestBuilderImp(
            endPointBuilder: mockEndPointBuilder,
            payloadBuilder: mockPayloadBuilder
        )
        
        struct Body: Encodable { let value: String }
        let endpoint = MockEndPoint(method: .post, path: "/encode")

        // Assert
        #expect {
            // Act
            _ = try builder.buildRequest(from: endpoint, body: Body(value: "X"))
        } throws: { error in
            guard case NetworkingError.encodingFailed = error else {
                return false
            }
            return true
        }
    }
}
