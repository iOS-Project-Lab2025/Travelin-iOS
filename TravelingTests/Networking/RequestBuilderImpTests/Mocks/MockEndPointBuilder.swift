//
//  MockEndPointBuilder.swift
//  TravelingTests
//
//  Created by Rodolfo Gonzalez on 16-12-25.
//

import Foundation
@testable import Traveling

// MARK: - Mock EndPointBuilder
final class MockEndPointBuilder: EndPointBuilderProtocol {
    var returnedURL: URL?
    var capturedEndpoint: EndPointProtocol?
    var thrownError: Error?
    
    func buildURL(from endPoint: EndPointProtocol) throws -> URL {
        capturedEndpoint = endPoint
        if let error = thrownError { throw error }
        return returnedURL ?? URL(string: "https://example.com/default")!
    }
}
