//
//  MockURLSession.swift
//  TravelingTests
//
//  Created by Rodolfo Gonzalez on 16-12-25.
//

import Foundation
@testable import Traveling

final class MockURLSession: URLSessionProtocol {
    var mockData: Data?
    var mockResponse: URLResponse?
    var mockError: Error?
    var dataWasCalled = false
    
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        dataWasCalled = true
        
        if let error = mockError {
            throw error
        }
        
        guard let data = mockData, let response = mockResponse else {
            throw URLError(.unknown)
        }
        
        return (data, response)
    }
}
