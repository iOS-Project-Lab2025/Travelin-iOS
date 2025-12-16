//
//  MockClient.swift
//  TravelingTests
//
//  Created by Rodolfo Gonzalez on 16-12-25.
//

@testable import Traveling
import Foundation

final class MockClient: NetworkClientProtocol {
    var returnedData: Data?
    var returnedResponse: URLResponse?
    var thrownError: Error?

    func execute(_ request: URLRequest) async throws -> (Data, URLResponse) {
        if let error = thrownError { throw error }
        return (returnedData ?? Data(), returnedResponse ?? URLResponse())
    }
}
