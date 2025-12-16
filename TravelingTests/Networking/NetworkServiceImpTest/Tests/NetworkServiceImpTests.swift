//
//  NetworkServiceImpTests.swift
//  TravelingTests
//
//  Created by Rodolfo Gonzalez on 16-12-25.
//

import Testing
@testable import Traveling
import Foundation

/// Test suite for validating the behavior of `NetworkServiceImp`.
///
/// These tests ensure that:
/// - Request building errors are propagated correctly
/// - Responses are validated before decoding
/// - Successful responses are decoded as expected
/// - HTTP status codes are mapped to the correct domain errors
/// - Network-level errors are translated into `NetworkingError` cases
@Suite("NetworkServiceImp Tests")
struct NetworkServiceImpTests {

    // MARK: - Request Building Tests

    /// Verifies that errors thrown by the request builder
    /// are propagated without modification.
    @Test("Execute should propagate RequestBuilder errors")
    func test_execute_propagatesRequestBuilderError() async {
        // Arrange
        let mockRequestBuilder = MockRequestBuilder()
        mockRequestBuilder.thrownError = NetworkingError.requestBuildingFailed("bad request")

        let service = NetworkServiceImp(
            client: MockClient(),
            requestBuilder: mockRequestBuilder
        )
        let endpoint = MockEndPoint(method: .get, path: "/test")

        // Assert
        await #expect {
            // Act
            _ = try await service.execute(endpoint, responseType: MockSuccessResponse.self)
        } throws: { error in
            guard case NetworkingError.requestBuildingFailed = error else { return false }
            return true
        }
    }

    // MARK: - Response Validation Tests

    /// Verifies that a non-HTTP response results
    /// in a transport-level error.
    @Test("Execute should throw transportError when response is not HTTPURLResponse")
    func test_execute_nonHTTPResponse_throwsTransportError() async {
        // Arrange
        let mockRequestBuilder = MockRequestBuilder()

        let mockClient = MockClient()
        mockClient.returnedResponse = URLResponse()

        let service = NetworkServiceImp(
            client: mockClient,
            requestBuilder: mockRequestBuilder
        )
        let endpoint = MockEndPoint(method: .get, path: "/test")

        // Assert
        await #expect {
            // Act
            _ = try await service.execute(endpoint, responseType: MockSuccessResponse.self)
        } throws: { error in
            guard case NetworkingError.transportError = error else { return false }
            return true
        }
    }

    // MARK: - Success Response Tests

    /// Verifies that a valid JSON response is decoded
    /// successfully into the expected response type.
    @Test("Execute should decode valid JSON response successfully")
    func test_execute_success_decodesCorrectly() async throws {
        // Arrange
        let mockRequestBuilder = MockRequestBuilder()
        let mockClient = MockClient()

        mockClient.returnedData = #"{"id":1,"name":"John"}"#.data(using: .utf8)!
        mockClient.returnedResponse = HTTPURLResponse(
            url: URL(string: "https://api.example.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: ["Content-Type": "application/json"]
        )

        let service = NetworkServiceImp(
            client: mockClient,
            requestBuilder: mockRequestBuilder
        )
        let endpoint = MockEndPoint(method: .get, path: "/user")

        // Act
        let response = try await service.execute(
            endpoint,
            responseType: MockSuccessResponse.self
        )

        // Assert
        #expect(response == MockSuccessResponse(id: 1, name: "John"))
    }

    /// Verifies that a non-JSON content type
    /// results in an `invalidContentType` error.
    @Test("Execute should throw invalidContentType for non-JSON content")
    func test_execute_invalidContentType_throwsError() async {
        // Arrange
        let mockRequestBuilder = MockRequestBuilder()
        let mockClient = MockClient()

        mockClient.returnedData = Data([1, 2, 3])
        mockClient.returnedResponse = HTTPURLResponse(
            url: URL(string: "https://api.example.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: ["Content-Type": "text/html"]
        )

        let service = NetworkServiceImp(
            client: mockClient,
            requestBuilder: mockRequestBuilder
        )
        let endpoint = MockEndPoint(method: .get, path: "/user")

        // Assert
        await #expect {
            // Act
            _ = try await service.execute(endpoint, responseType: MockSuccessResponse.self)
        } throws: { error in
            guard case NetworkingError.invalidContentType = error else { return false }
            return true
        }
    }

    /// Verifies that an empty response body
    /// results in an `emptyResponse` error.
    @Test("Execute should throw emptyResponse when data is empty")
    func test_execute_emptyResponse_throws() async {
        // Arrange
        let mockRequestBuilder = MockRequestBuilder()
        let mockClient = MockClient()

        mockClient.returnedData = Data()
        mockClient.returnedResponse = HTTPURLResponse(
            url: URL(string: "https://api.example.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: ["Content-Type": "application/json"]
        )

        let service = NetworkServiceImp(
            client: mockClient,
            requestBuilder: mockRequestBuilder
        )
        let endpoint = MockEndPoint(method: .get, path: "/user")

        // Assert
        await #expect {
            // Act
            _ = try await service.execute(endpoint, responseType: MockSuccessResponse.self)
        } throws: { error in
            guard case NetworkingError.emptyResponse = error else { return false }
            return true
        }
    }

    /// Verifies that invalid JSON structures
    /// result in a `decodingFailed` error.
    @Test("Execute should throw decodingFailed when JSON structure is invalid")
    func test_execute_decodingFailure_throws() async {
        // Arrange
        let mockRequestBuilder = MockRequestBuilder()
        let mockClient = MockClient()

        mockClient.returnedData = #"{"wrong":123}"#.data(using: .utf8)!
        mockClient.returnedResponse = HTTPURLResponse(
            url: URL(string: "https://api.example.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: ["Content-Type": "application/json"]
        )

        let service = NetworkServiceImp(
            client: mockClient,
            requestBuilder: mockRequestBuilder
        )
        let endpoint = MockEndPoint(method: .get, path: "/user")

        // Assert
        await #expect {
            // Act
            _ = try await service.execute(endpoint, responseType: MockSuccessResponse.self)
        } throws: { error in
            guard case NetworkingError.decodingFailed = error else { return false }
            return true
        }
    }

    // MARK: - HTTP Error Tests

    /// Verifies that 4xx HTTP responses are mapped
    /// to `serverError` with the parsed error message.
    @Test("Execute should throw serverError for 4xx status codes with parsed message")
    func test_execute_clientError_throwsServerError() async {
        // Arrange
        let mockRequestBuilder = MockRequestBuilder()
        let mockClient = MockClient()

        mockClient.returnedData = #"{"message":"Bad request"}"#.data(using: .utf8)!
        mockClient.returnedResponse = HTTPURLResponse(
            url: URL(string: "https://api.example.com")!,
            statusCode: 400,
            httpVersion: nil,
            headerFields: ["Content-Type": "application/json"]
        )

        let service = NetworkServiceImp(
            client: mockClient,
            requestBuilder: mockRequestBuilder
        )
        let endpoint = MockEndPoint(method: .get, path: "/test")

        // Assert
        await #expect {
            // Act
            _ = try await service.execute(endpoint, responseType: MockSuccessResponse.self)
        } throws: { error in
            guard case let NetworkingError.serverError(code, message) = error else { return false }
            return code == 400 && message == "Bad request"
        }
    }

    /// Verifies that 5xx HTTP responses are mapped
    /// to `serverError` with the parsed error message.
    @Test("Execute should throw serverError for 5xx status codes with parsed message")
    func test_execute_serverError_throwsServerError() async {
        // Arrange
        let mockRequestBuilder = MockRequestBuilder()
        let mockClient = MockClient()

        mockClient.returnedData = #"{"message":"Internal error"}"#.data(using: .utf8)!
        mockClient.returnedResponse = HTTPURLResponse(
            url: URL(string: "https://api.example.com")!,
            statusCode: 500,
            httpVersion: nil,
            headerFields: ["Content-Type": "application/json"]
        )

        let service = NetworkServiceImp(
            client: mockClient,
            requestBuilder: mockRequestBuilder
        )
        let endpoint = MockEndPoint(method: .get, path: "/test")

        // Assert
        await #expect {
            // Act
            _ = try await service.execute(endpoint, responseType: MockSuccessResponse.self)
        } throws: { error in
            guard case let NetworkingError.serverError(code, message) = error else { return false }
            return code == 500 && message == "Internal error"
        }
    }

    // MARK: - Network Error Mapping Tests

    /// Verifies that a `notConnectedToInternet` URL error
    /// is mapped to `NetworkingError.noConnection`.
    @Test("Execute should map URLError.notConnectedToInternet to noConnection")
    func test_execute_notConnected_throwsNoConnection() async {
        // Arrange
        let mockRequestBuilder = MockRequestBuilder()

        let mockClient = MockClient()
        mockClient.thrownError = URLError(.notConnectedToInternet)

        let service = NetworkServiceImp(
            client: mockClient,
            requestBuilder: mockRequestBuilder
        )
        let endpoint = MockEndPoint(method: .get, path: "/test")

        // Assert
        await #expect {
            // Act
            _ = try await service.execute(endpoint, responseType: MockSuccessResponse.self)
        } throws: { error in
            guard case NetworkingError.noConnection = error else { return false }
            return true
        }
    }

    /// Verifies that a `timedOut` URL error
    /// is mapped to `NetworkingError.timeout`.
    @Test("Execute should map URLError.timedOut to timeout")
    func test_execute_timeout_throwsTimeout() async {
        // Arrange
        let mockRequestBuilder = MockRequestBuilder()

        let mockClient = MockClient()
        mockClient.thrownError = URLError(.timedOut)

        let service = NetworkServiceImp(
            client: mockClient,
            requestBuilder: mockRequestBuilder
        )
        let endpoint = MockEndPoint(method: .get, path: "/test")

        // Assert
        await #expect {
            // Act
            _ = try await service.execute(endpoint, responseType: MockSuccessResponse.self)
        } throws: { error in
            guard case NetworkingError.timeout = error else { return false }
            return true
        }
    }

    /// Verifies that other URL errors
    /// are mapped to `NetworkingError.transportError`.
    @Test("Execute should map other URLErrors to transportError")
    func test_execute_otherURLError_throwsTransportError() async {
        // Arrange
        let mockRequestBuilder = MockRequestBuilder()

        let mockClient = MockClient()
        mockClient.thrownError = URLError(.cannotFindHost)

        let service = NetworkServiceImp(
            client: mockClient,
            requestBuilder: mockRequestBuilder
        )
        let endpoint = MockEndPoint(method: .get, path: "/test")

        // Assert
        await #expect {
            // Act
            _ = try await service.execute(endpoint, responseType: MockSuccessResponse.self)
        } throws: { error in
            guard case NetworkingError.transportError = error else { return false }
            return true
        }
    }

    /// Verifies that unknown errors
    /// are mapped to `NetworkingError.unknown`.
    @Test("Execute should map unknown errors to NetworkingError.unknown")
    func test_execute_unknownError_throwsUnknown() async {
        // Arrange
        let mockRequestBuilder = MockRequestBuilder()

        let mockClient = MockClient()
        mockClient.thrownError = NSError(domain: "X", code: 999)

        let service = NetworkServiceImp(
            client: mockClient,
            requestBuilder: mockRequestBuilder
        )
        let endpoint = MockEndPoint(method: .get, path: "/test")

        // Assert
        await #expect {
            // Act
            _ = try await service.execute(endpoint, responseType: MockSuccessResponse.self)
        } throws: { error in
            guard case NetworkingError.unknown = error else { return false }
            return true
        }
    }
}
