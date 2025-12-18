//
//  EndPointBuilderImpTests.swift
//  TravelingUITests
//
//  Created by Rodolfo Gonzalez on 15-12-25.
//

import Testing
@testable import Traveling
import Foundation

/// Test suite for validating the behavior of `EndPointBuilderImp`.
///
/// These tests ensure that:
/// - The builder validates base URLs correctly during initialization
/// - Invalid base URLs result in the expected errors
/// - URLs are correctly constructed from endpoint definitions
/// - Query parameters are appended properly
@Suite("EndPointBuilderImp Tests")
struct EndPointBuilderImpTests {
    
    // MARK: - Init Tests

    /// Verifies that `EndPointBuilderImp` initializes successfully
    /// when provided with a valid base URL.
    @Test("Init should succeed with a base URL")
    func testEndPointBuilder_init_validBaseUrl() {
        /*
         // Arrange - given
         // Act - Then
         // Assert - Expect
         */
        // Arrange
        // Given a well-formed base URL
        let baseURL = "https://example.com"
       
        // Assert
        // Expect no error to be thrown during initialization
        #expect(throws: Never.self) {
            // Act
            _ = try EndPointBuilderImp(baseURL: baseURL)
        }
    }
    
    /// Verifies that initialization throws `NetworkingError.invalidURL`
    /// when the provided base URL is malformed.
    @Test("Init should throw NetworkingError.invalidURL for malformed base URL")
    func testEndPointBuilder_init_invalidBaseUrl() {
        // Arrange
        // Given a malformed base URL
        let baseURL = "ht!ps://example.c!m"

        // Assert
        // Expect initialization to throw an invalid URL error
        #expect {
            // Act
            _ = try EndPointBuilderImp(baseURL: baseURL)
        } throws: { error in
            guard case NetworkingError.invalidURL = error else {
                return false
            }
            return true
        }
    }

    /// Verifies that initialization throws `NetworkingError.invalidURL`
    /// when the URL scheme is missing.
    @Test("Init should throw when scheme is missing from base URL")
    func testEndPointBuilder_init_missingScheme() {
        // Arrange
        // Given a base URL without a scheme
        let baseURL = "example.com"

        // Assert
        // Expect initialization to fail due to invalid URL
        #expect {
            // Act
            _ = try EndPointBuilderImp(baseURL: baseURL)
        } throws: { error in
            guard case NetworkingError.invalidURL = error else {
                return false
            }
            return true
        }
    }

    /// Verifies that initialization throws `NetworkingError.invalidURL`
    /// when the URL host is missing.
    @Test("Init should throw when host is missing from base URL")
    func testEndPointBuilder_init_missingHost() {
        // Arrange
        // Given a base URL without a host
        let baseURL = "https://"

        // Assert
        // Expect initialization to fail due to invalid URL
        #expect {
            // Act
            _ = try EndPointBuilderImp(baseURL: baseURL)
        } throws: { error in
            guard case NetworkingError.invalidURL = error else {
                return false
            }
            return true
        }
    }

    // MARK: - Build URL Tests

    /// Verifies that `buildURL(from:)` constructs the correct
    /// full URL by combining:
    /// - The base URL
    /// - The endpoint path
    /// - The provided query items
    ///
    /// This test also validates that the generated URL
    /// is captured by the networking debug utility.
    @Test("buildURL should return correct full URL including query items")
    func testEndPointBuilder_buildURL_correctURL() {
        // Arrange
        // Given an endpoint with path and query parameters
        let endpoint = MockEndPoint(
            method: .get,
            path: "/search",
            queryItems: [
                URLQueryItem(name: "q", value: "poi"),
                URLQueryItem(name: "limit", value: "10")
            ]
        )
        
        // Assert
        // Expect URL construction to succeed without errors
        #expect(throws: Never.self) {
            // Act
            let builder = try EndPointBuilderImp(baseURL: "https://api.example.com")
            let url = try builder.buildURL(from: endpoint)
            
            // Then
            // Verify the resulting URL and debug tracking value
            #expect(url.absoluteString == "https://api.example.com/search?q=poi&limit=10")
            #expect(NetworkDebug.lastURL == url.absoluteString)
        }
    }
}
