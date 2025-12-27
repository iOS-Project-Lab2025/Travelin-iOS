//
//  NetworkClientImpTests.swift
//  TravelingTests
//
//  Created by Rodolfo Gonzalez on 16-12-25.
//

import Testing
@testable import Traveling
import Foundation

/// Test suite for validating the behavior of `NetworkClient`.
///
/// These tests ensure that:
/// - The client initializes correctly with default and custom sessions
/// - Network requests are delegated to the underlying session
/// - Errors from the session are propagated without modification
/// - Returned data and responses are not altered
@Suite("NetworkClient Tests")
struct NetworkClientImpTests {

    // MARK: - Init Tests

    /// Verifies that `NetworkClient` initializes successfully
    /// using the default `URLSession`.
    @Test("Init should succeed with default URLSession")
    func testNetworkClient_init_defaultSession() {
        // Arrange / Act
        let client = NetworkClient()

        // Assert
        // If initialization fails, the test would crash before this point
        #expect(type(of: client) == NetworkClient.self)
    }

    /// Verifies that `NetworkClient` accepts a custom
    /// `URLSessionProtocol` implementation during initialization.
    @Test("Init should accept a custom URLSessionProtocol")
    func testNetworkClient_init_customSession() {
        // Arrange
        let customSession = URLSession.shared

        // Act
        let client = NetworkClient(session: customSession)

        // Assert
        #expect(type(of: client) == NetworkClient.self)
    }

    // MARK: - Execute Tests

    /// Verifies that `execute(_:)` delegates the request execution
    /// to the underlying `URLSessionProtocol`.
    @Test("Execute should call data(for:) on URLSessionProtocol")
    func testNetworkClient_execute_callsURLSession() async throws {
        // Arrange
        let mockSession = MockURLSession()
        let client = NetworkClient(session: mockSession)

        mockSession.mockData = Data()
        mockSession.mockResponse = URLResponse()
        let request = URLRequest(url: URL(string: "https://api.example.com")!)

        // Act
        let _: (Data, URLResponse) = try await (client as NetworkClientProtocol).execute(request)

        // Assert
        #expect(mockSession.dataWasCalled)
    }

    /// Verifies that errors thrown by the underlying session
    /// are propagated without being altered or wrapped.
    @Test("Execute should propagate URLSession errors unchanged")
    func testNetworkClient_execute_throwsURLSessionError() async {
        // Arrange
        let mockSession = MockURLSession()
        let client = NetworkClient(session: mockSession)

        mockSession.mockError = URLError(.notConnectedToInternet)
        let request = URLRequest(url: URL(string: "https://api.example.com")!)

        // Assert
        await #expect {
            let _: (Data, URLResponse) = try await (client as NetworkClientProtocol).execute(request)
        } throws: { error in
            guard let urlError = error as? URLError else {
                return false
            }
            return urlError.code == .notConnectedToInternet
        }
    }

    /// Verifies that a timeout error from the underlying session
    /// is propagated without modification.
    @Test("Execute should propagate timeout error unchanged")
    func testNetworkClient_execute_throwsTimeoutError() async {
        // Arrange
        let mockSession = MockURLSession()
        let client = NetworkClient(session: mockSession)

        mockSession.mockError = URLError(.timedOut)
        let request = URLRequest(url: URL(string: "https://api.example.com")!)

        // Assert
        await #expect {
            let _: (Data, URLResponse) = try await (client as NetworkClientProtocol).execute(request)
        } throws: { error in
            guard let urlError = error as? URLError else {
                return false
            }
            return urlError.code == .timedOut
        }
    }

    /// Verifies that `execute(_:)` returns the exact
    /// `(Data, URLResponse)` tuple provided by the session,
    /// without altering or copying the values.
    @Test("Execute should return the exact tuple from URLSessionProtocol")
    func testNetworkClient_execute_returnsTupleUnmodified() async throws {
        // Arrange
        let mockSession = MockURLSession()
        let client = NetworkClient(session: mockSession)

        let expectedData = Data([1, 2, 3])
        let expectedResponse = URLResponse()

        mockSession.mockData = expectedData
        mockSession.mockResponse = expectedResponse

        let request = URLRequest(url: URL(string: "https://api.example.com")!)

        // Act
        let (data, response) = try await client.execute(request)

        // Assert
        #expect(data == expectedData)
        #expect(response === expectedResponse)
    }
}
