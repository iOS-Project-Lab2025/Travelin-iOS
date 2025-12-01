//
//  URLSessionClient.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 19-11-25.
//

import Foundation

final class NetworkClientImp: NetworkClientProtocol {
    private let session: URLSession
    init(session: URLSession = .shared) {
        self.session = session
    }
    func execute(_ request: URLRequest) async throws -> (Data, URLResponse) {
        return try await self.session.data(for: request)
    }
}



