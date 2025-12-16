//
//  RequestBuilderImpTests.swift
//  TravelingTests
//
//  Created by Rodolfo Gonzalez on 16-12-25.
//

import Testing
import Foundation
@testable import Traveling

@Suite("RequestBuilderImp Tests")
struct RequestBuilderImpTests {

    // MARK: - BUILD REQUEST TESTS

    @Test("buildRequest should call EndPointBuilder and assign returned URL")
    func testRequestBuilder_buildRequest_assignsCorrectURL() throws {
        // Arrange - given
        let mockEndPointBuilder = MockEndPointBuilder()
        mockEndPointBuilder.returnedURL = URL(string: "https://test.com/user")!
        
        let builder = RequestBuilderImp(endPointBuilder: mockEndPointBuilder)
        let endpoint = MockEndPoint(method: .get, path: "/user")

        // Act - Then
        let request = try builder.buildRequest(from: endpoint)

        // Assert - Expect
        #expect(request.url?.absoluteString == "https://test.com/user")
        #expect(mockEndPointBuilder.capturedEndpoint?.path == "/user")
    }

    @Test("buildRequest should apply correct HTTP method")
    func testRequestBuilder_buildRequest_setsHTTPMethod() throws {
        // Arrange - given
        let mockEndPointBuilder = MockEndPointBuilder()
        mockEndPointBuilder.returnedURL = URL(string: "https://example.com")!
        
        let builder = RequestBuilderImp(endPointBuilder: mockEndPointBuilder)
        let endpoint = MockEndPoint(method: .post, path: "/login")

        // Act - Then
        let request = try builder.buildRequest(from: endpoint)

        // Assert - Expect
        #expect(request.httpMethod == "POST")
    }

    @Test("buildRequest should merge common and endpoint headers with correct precedence")
    func testRequestBuilder_buildRequest_mergesHeadersCorrectly() throws {
        // Arrange - given
        let mockEndPointBuilder = MockEndPointBuilder()
        mockEndPointBuilder.returnedURL = URL(string: "https://example.com")!
        
        let builder = RequestBuilderImp(endPointBuilder: mockEndPointBuilder)
        let endpoint = MockEndPoint(
            method: .get,
            path: "/",
            headers: [
                "Accept": "image/png",  // overrides common header
                "Custom": "XYZ"
            ]
        )

        // Act - Then
        let request = try builder.buildRequest(from: endpoint)

        // Assert - Expect
        let headers = request.allHTTPHeaderFields!
        #expect(headers["Accept"] == "image/png")
        #expect(headers["Custom"] == "XYZ")
        #expect(headers["App-Version"] == "1.0")
    }

    @Test("buildRequest should always set 30s timeout")
    func testRequestBuilder_buildRequest_setsTimeout() throws {
        // Arrange - given
        let mockEndPointBuilder = MockEndPointBuilder()
        mockEndPointBuilder.returnedURL = URL(string: "https://example.com")!
        
        let builder = RequestBuilderImp(endPointBuilder: mockEndPointBuilder)
        let endpoint = MockEndPoint(method: .get, path: "/timeout")

        // Act - Then
        let request = try builder.buildRequest(from: endpoint)

        // Assert - Expect
        #expect(request.timeoutInterval == 30)
    }

    @Test("buildRequest should attach encoded body using PayloadBuilder")
    func testRequestBuilder_buildRequest_attachesBody() throws {
        // Arrange - given
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

        // Act - Then
        let request = try builder.buildRequest(from: endpoint, body: Body(name: "John"))

        // Assert - Expect
        #expect(request.httpBody == Data([1, 2, 3]))
        #expect(mockPayloadBuilder.capturedModel is Body)
    }

    // MARK: - ERROR TESTS

    @Test("buildRequest should propagate URL building error from EndPointBuilder")
    func testRequestBuilder_buildRequest_propagatesURLError() {
        // Arrange - given
        let mockEndPointBuilder = MockEndPointBuilder()
        mockEndPointBuilder.thrownError = NetworkingError.invalidURL(URLError(.badURL))
        
        let builder = RequestBuilderImp(endPointBuilder: mockEndPointBuilder)
        let endpoint = MockEndPoint(method: .get, path: "/bad")

        // Assert - Expect
        #expect {
            // Act - Then
            _ = try builder.buildRequest(from: endpoint)
        } throws: { error in
            guard case NetworkingError.invalidURL = error else {
                return false
            }
            return true
        }
    }

    @Test("buildRequest should throw requestBuildingFailed when body exists but PayloadBuilder is nil")
    func testRequestBuilder_buildRequest_throwsMissingPayloadBuilder() {
        // Arrange - given
        let mockEndPointBuilder = MockEndPointBuilder()
        mockEndPointBuilder.returnedURL = URL(string: "https://example.com")!
        
        let builder = RequestBuilderImp(endPointBuilder: mockEndPointBuilder)
        
        struct Body: Encodable { let id: Int }
        let endpoint = MockEndPoint(method: .post, path: "/create")

        // Assert - Expect
        #expect {
            // Act - Then
            _ = try builder.buildRequest(from: endpoint, body: Body(id: 1))
        } throws: { error in
            guard case NetworkingError.requestBuildingFailed = error else {
                return false
            }
            return true
        }
    }

    @Test("buildRequest should propagate encoding errors from PayloadBuilder")
    func testRequestBuilder_buildRequest_propagatesEncodingError() {
        // Arrange - given
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

        // Assert - Expect
        #expect {
            // Act - Then
            _ = try builder.buildRequest(from: endpoint, body: Body(value: "X"))
        } throws: { error in
            guard case NetworkingError.encodingFailed = error else {
                return false
            }
            return true
        }
    }
}
