//
//  MockRequestBuilder.swift
//  TravelingTests
//
//  Created by Rodolfo Gonzalez on 16-12-25.
//

@testable import Traveling
import Foundation

final class MockRequestBuilder: RequestBuilderProtocol {
    var thrownError: Error?

    func buildRequest(from endPoint: EndPointProtocol,
                      body: Encodable?) throws -> URLRequest {
        if let error = thrownError { throw error }
        return URLRequest(url: URL(string: "https://api.test.com/ok")!)
    }
}
