//
//  NetworkServiceImpTests.swift
//  TravelingTests
//
//  Created by Rodolfo Gonzalez on 16-12-25.
//

import Testing
@testable import Traveling
import Foundation

@Suite("NetworkServiceImp Tests")
struct NetworkServiceImpTests {

    // MARK: - REQUEST BUILDING TESTS

    @Test("Execute should propagate RequestBuilder errors")
    func test_execute_propagatesRequestBuilderError() async {
        // Arrange - given
        let mockRequestBuilder = MockRequestBuilder()
        mockRequestBuilder.thrownError = NetworkingError.requestBuildingFailed("bad request")

        let service = NetworkServiceImp(client: MockClient(),
                                        requestBuilder: mockRequestBuilder)
        let endpoint = MockEndPoint(method: .get, path: "/test")

        // Assert - Expect
        await #expect {
            // Act - Then
            _ = try await service.execute(endpoint, responseType: MockSuccessResponse.self)
        } throws: { error in
            guard case NetworkingError.requestBuildingFailed = error else { return false }
            return true
        }
    }

    // MARK: - RESPONSE VALIDATION TESTS

    @Test("Execute should throw transportError when response is not HTTPURLResponse")
    func test_execute_nonHTTPResponse_throwsTransportError() async {
        // Arrange - given
        let mockRequestBuilder = MockRequestBuilder()

        let mockClient = MockClient()
        mockClient.returnedResponse = URLResponse()

        let service = NetworkServiceImp(client: mockClient,
                                        requestBuilder: mockRequestBuilder)
        let endpoint = MockEndPoint(method: .get, path: "/test")

        // Assert - Expect
        await #expect {
            // Act - Then
            _ = try await service.execute(endpoint, responseType: MockSuccessResponse.self)
        } throws: { error in
            guard case NetworkingError.transportError = error else { return false }
            return true
        }
    }

    // MARK: - SUCCESS RESPONSE TESTS

    @Test("Execute should decode valid JSON response successfully")
    func test_execute_success_decodesCorrectly() async throws {
        // Arrange - given
        let mockRequestBuilder = MockRequestBuilder()
        let mockClient = MockClient()

        mockClient.returnedData = #"{"id":1,"name":"John"}"#.data(using: .utf8)!
        mockClient.returnedResponse = HTTPURLResponse(
            url: URL(string: "https://api.example.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: ["Content-Type": "application/json"]
        )

        let service = NetworkServiceImp(client: mockClient,
                                        requestBuilder: mockRequestBuilder)
        let endpoint = MockEndPoint(method: .get, path: "/user")

        // Act - Then
        let response = try await service.execute(endpoint, responseType: MockSuccessResponse.self)

        // Assert - Expect
        #expect(response == MockSuccessResponse(id: 1, name: "John"))
    }

    @Test("Execute should throw invalidContentType for non-JSON content")
    func test_execute_invalidContentType_throwsError() async {
        // Arrange - given
        let mockRequestBuilder = MockRequestBuilder()
        let mockClient = MockClient()

        mockClient.returnedData = Data([1, 2, 3])
        mockClient.returnedResponse = HTTPURLResponse(
            url: URL(string: "https://api.example.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: ["Content-Type": "text/html"]
        )

        let service = NetworkServiceImp(client: mockClient,
                                        requestBuilder: mockRequestBuilder)
        let endpoint = MockEndPoint(method: .get, path: "/user")

        // Assert - Expect
        await #expect {
            // Act - Then
            _ = try await service.execute(endpoint, responseType: MockSuccessResponse.self)
        } throws: { error in
            guard case NetworkingError.invalidContentType = error else { return false }
            return true
        }
    }

    @Test("Execute should throw emptyResponse when data is empty")
    func test_execute_emptyResponse_throws() async {
        // Arrange - given
        let mockRequestBuilder = MockRequestBuilder()
        let mockClient = MockClient()

        mockClient.returnedData = Data()
        mockClient.returnedResponse = HTTPURLResponse(
            url: URL(string: "https://api.example.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: ["Content-Type": "application/json"]
        )

        let service = NetworkServiceImp(client: mockClient,
                                        requestBuilder: mockRequestBuilder)
        let endpoint = MockEndPoint(method: .get, path: "/user")

        // Assert - Expect
        await #expect {
            // Act - Then
            _ = try await service.execute(endpoint, responseType: MockSuccessResponse.self)
        } throws: { error in
            guard case NetworkingError.emptyResponse = error else { return false }
            return true
        }
    }

    @Test("Execute should throw decodingFailed when JSON structure is invalid")
    func test_execute_decodingFailure_throws() async {
        // Arrange - given
        let mockRequestBuilder = MockRequestBuilder()
        let mockClient = MockClient()

        mockClient.returnedData = #"{"wrong":123}"#.data(using: .utf8)!
        mockClient.returnedResponse = HTTPURLResponse(
            url: URL(string: "https://api.example.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: ["Content-Type": "application/json"]
        )

        let service = NetworkServiceImp(client: mockClient,
                                        requestBuilder: mockRequestBuilder)
        let endpoint = MockEndPoint(method: .get, path: "/user")

        // Assert - Expect
        await #expect {
            // Act - Then
            _ = try await service.execute(endpoint, responseType: MockSuccessResponse.self)
        } throws: { error in
            guard case NetworkingError.decodingFailed = error else { return false }
            return true
        }
    }

    // MARK: - HTTP ERROR TESTS

    @Test("Execute should throw serverError for 4xx status codes with parsed message")
    func test_execute_clientError_throwsServerError() async {
        // Arrange - given
        let mockRequestBuilder = MockRequestBuilder()
        let mockClient = MockClient()

        mockClient.returnedData = #"{"message":"Bad request"}"#.data(using: .utf8)!
        mockClient.returnedResponse = HTTPURLResponse(
            url: URL(string: "https://api.example.com")!,
            statusCode: 400,
            httpVersion: nil,
            headerFields: ["Content-Type": "application/json"]
        )

        let service = NetworkServiceImp(client: mockClient,
                                        requestBuilder: mockRequestBuilder)
        let endpoint = MockEndPoint(method: .get, path: "/test")

        // Assert - Expect
        await #expect {
            // Act - Then
            _ = try await service.execute(endpoint, responseType: MockSuccessResponse.self)
        } throws: { error in
            guard case let NetworkingError.serverError(code, message) = error else { return false }
            return code == 400 && message == "Bad request"
        }
    }

    @Test("Execute should throw serverError for 5xx status codes with parsed message")
    func test_execute_serverError_throwsServerError() async {
        // Arrange - given
        let mockRequestBuilder = MockRequestBuilder()
        let mockClient = MockClient()

        mockClient.returnedData = #"{"message":"Internal error"}"#.data(using: .utf8)!
        mockClient.returnedResponse = HTTPURLResponse(
            url: URL(string: "https://api.example.com")!,
            statusCode: 500,
            httpVersion: nil,
            headerFields: ["Content-Type": "application/json"]
        )

        let service = NetworkServiceImp(client: mockClient,
                                        requestBuilder: mockRequestBuilder)
        let endpoint = MockEndPoint(method: .get, path: "/test")

        // Assert - Expect
        await #expect {
            // Act - Then
            _ = try await service.execute(endpoint, responseType: MockSuccessResponse.self)
        } throws: { error in
            guard case let NetworkingError.serverError(code, message) = error else { return false }
            return code == 500 && message == "Internal error"
        }
    }

    // MARK: - NETWORK ERROR TESTS

    @Test("Execute should map URLError.notConnectedToInternet to noConnection")
    func test_execute_notConnected_throwsNoConnection() async {
        // Arrange - given
        let mockRequestBuilder = MockRequestBuilder()

        let mockClient = MockClient()
        mockClient.thrownError = URLError(.notConnectedToInternet)

        let service = NetworkServiceImp(client: mockClient,
                                        requestBuilder: mockRequestBuilder)
        let endpoint = MockEndPoint(method: .get, path: "/test")

        // Assert - Expect
        await #expect {
            // Act - Then
            _ = try await service.execute(endpoint, responseType: MockSuccessResponse.self)
        } throws: { error in
            guard case NetworkingError.noConnection = error else { return false }
            return true
        }
    }

    @Test("Execute should map URLError.timedOut to timeout")
    func test_execute_timeout_throwsTimeout() async {
        // Arrange - given
        let mockRequestBuilder = MockRequestBuilder()

        let mockClient = MockClient()
        mockClient.thrownError = URLError(.timedOut)

        let service = NetworkServiceImp(client: mockClient,
                                        requestBuilder: mockRequestBuilder)
        let endpoint = MockEndPoint(method: .get, path: "/test")

        // Assert - Expect
        await #expect {
            // Act - Then
            _ = try await service.execute(endpoint, responseType: MockSuccessResponse.self)
        } throws: { error in
            guard case NetworkingError.timeout = error else { return false }
            return true
        }
    }

    @Test("Execute should map other URLErrors to transportError")
    func test_execute_otherURLError_throwsTransportError() async {
        // Arrange - given
        let mockRequestBuilder = MockRequestBuilder()

        let mockClient = MockClient()
        mockClient.thrownError = URLError(.cannotFindHost)

        let service = NetworkServiceImp(client: mockClient,
                                        requestBuilder: mockRequestBuilder)
        let endpoint = MockEndPoint(method: .get, path: "/test")

        // Assert - Expect
        await #expect {
            // Act - Then
            _ = try await service.execute(endpoint, responseType: MockSuccessResponse.self)
        } throws: { error in
            guard case NetworkingError.transportError = error else { return false }
            return true
        }
    }

    @Test("Execute should map unknown errors to NetworkingError.unknown")
    func test_execute_unknownError_throwsUnknown() async {
        // Arrange - given
        let mockRequestBuilder = MockRequestBuilder()

        let mockClient = MockClient()
        mockClient.thrownError = NSError(domain: "X", code: 999)

        let service = NetworkServiceImp(client: mockClient,
                                        requestBuilder: mockRequestBuilder)
        let endpoint = MockEndPoint(method: .get, path: "/test")

        // Assert - Expect
        await #expect {
            // Act - Then
            _ = try await service.execute(endpoint, responseType: MockSuccessResponse.self)
        } throws: { error in
            guard case NetworkingError.unknown = error else { return false }
            return true
        }
    }
}

