//
//  EndPointBuilderImpTests.swift
//  TravelingUITests
//
//  Created by Rodolfo Gonzalez on 15-12-25.
//

import Testing
@testable import Traveling
import Foundation

@Suite("EndPointBuilderImp Tests")
struct EndPointBuilderImpTests {
    
    // MARK: - INIT TESTS
    @Test("Init should succeed with a base URL")
    func testEndPointBuilder_init_validBaseUrl() {
        /*
         // Arrange - given
         // Act - Then
         // Assert - Expect
         */
        // Arrange - given
        let baseURL = "https://example.com"
       
        // Assert - Expect
        #expect(throws: Never.self) {
            // Act - Then
            _ = try EndPointBuilderImp(baseURL: baseURL)
        }
    }
    
    @Test("Init should throw NetworkingError.invalidURL for malformed base URL")
    func testEndPointBuilder_init_invalidBaseUrl() {
        // Arrange - given
        let baseURL = "ht!ps://example.c!m"//"https://example.com"
        // Assert - Expect
        #expect {
            // Act - Then
            _ = try EndPointBuilderImp(baseURL: baseURL)
        } throws: { error in
            guard case NetworkingError.invalidURL = error else {
                return false
            }
            return true
        }
    }
    @Test("Init should throw when scheme is missing from base URL")
    func testEndPointBuilder_init_missingScheme() {
        // Arrange - given
        let baseURL = "example.com"
        // Assert - Expect
        #expect {
            // Act - Then
            _ = try EndPointBuilderImp(baseURL: baseURL)
        } throws: { error in
            guard case NetworkingError.invalidURL = error else {
                return false
            }
            return true
        }
    }
    @Test("Init should throw when host is missing from base URL")
    func testEndPointBuilder_init_missingHost() {
        // Arrange - given
        let baseURL = "https://"
        // Assert - Expect
        #expect {
            // Act - Then
            _ = try EndPointBuilderImp(baseURL: baseURL)
        } throws: { error in
            guard case NetworkingError.invalidURL = error else {
                return false
            }
            return true
        }
    }
    //MARK: - BUILD URL TEST
    @Test("buildURL should return correct full URL including query items")
    func testEndPointBuilder_buildURL_correctURL() {
        // Arrange - given
        let endpoint = MockEndPoint(
            method: .get,
                path: "/search",
                queryItems: [
                    URLQueryItem(name: "q", value: "poi"),
                    URLQueryItem(name: "limit", value: "10")
                ]
            )
        
        // Assert - Expect
        #expect(throws: Never.self) {
            // Act - Then
            let builder = try EndPointBuilderImp(baseURL: "https://api.example.com")
            let url = try builder.buildURL(from: endpoint)
            
            #expect(url.absoluteString == "https://api.example.com/search?q=poi&limit=10")
            #expect(NetworkDebug.lastURL == url.absoluteString)
        }
    }
}
