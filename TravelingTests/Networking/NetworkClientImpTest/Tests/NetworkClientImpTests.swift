//
//  NetworkClientImpTests.swift
//  TravelingTests
//
//  Created by Rodolfo Gonzalez on 16-12-25.
//

import Testing
@testable import Traveling
import Foundation

@Suite("NetworkClientImp Tests")
struct NetworkClientImpTests {

    // MARK: - INIT TESTS

    @Test("Init should succeed with default URLSession")
    func testNetworkClient_init_defaultSession() {
        // Arrange / Act
        let client = NetworkClientImp()

        // Assert (si init fallara, crashearía el test)
        #expect(type(of: client) == NetworkClientImp.self)
    }

    @Test("Init should accept a custom URLSessionProtocol")
    func testNetworkClient_init_customSession() {
        // Arrange
        let customSession = URLSession.shared

        // Act
        let client = NetworkClientImp(session: customSession)

        // Assert
        #expect(type(of: client) == NetworkClientImp.self)
    }

    // MARK: - EXECUTE TESTS

    @Test("Execute should call data(for:) on URLSessionProtocol")
    func testNetworkClient_execute_callsURLSession() async throws {
        // Arrange
        let mockSession = MockURLSession()
        let client = NetworkClientImp(session: mockSession)

        mockSession.mockData = Data()
        mockSession.mockResponse = URLResponse()
        let request = URLRequest(url: URL(string: "https://api.example.com")!)

        // Act
        _ = try await client.execute(request)

        // Assert
        #expect(mockSession.dataWasCalled)
    }

    @Test("Execute should propagate URLSession errors unchanged")
    func testNetworkClient_execute_throwsURLSessionError() async {
        // Arrange
        let mockSession = MockURLSession()
        let client = NetworkClientImp(session: mockSession)

        mockSession.mockError = URLError(.notConnectedToInternet)
        let request = URLRequest(url: URL(string: "https://api.example.com")!)

        // Assert
        await #expect {
            _ = try await client.execute(request)
        } throws: { error in
            guard let urlError = error as? URLError else {
                return false
            }
            return urlError.code == .notConnectedToInternet
        }
    }

    @Test("Execute should propagate timeout error unchanged")
    func testNetworkClient_execute_throwsTimeoutError() async {
        // Arrange
        let mockSession = MockURLSession()
        let client = NetworkClientImp(session: mockSession)

        mockSession.mockError = URLError(.timedOut)
        let request = URLRequest(url: URL(string: "https://api.example.com")!)

        // Assert
        await #expect {
            _ = try await client.execute(request)
        } throws: { error in
            guard let urlError = error as? URLError else {
                return false
            }
            return urlError.code == .timedOut
        }
    }

    @Test("Execute should return the exact tuple from URLSessionProtocol")
    func testNetworkClient_execute_returnsTupleUnmodified() async throws {
        // Arrange
        let mockSession = MockURLSession()
        let client = NetworkClientImp(session: mockSession)

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

