//
//  URLSessionClient.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 19-11-25.
//

import Foundation

/// Simple network client for basic requests without authentication.
///
/// This client:
/// - Returns both Data and URLResponse
/// - Does NOT handle token injection or refresh
/// - Does NOT have interceptor support
/// - Is ideal for public endpoints (login, register, etc.)
///
final class URLNetworkClient: NetworkClientProtocol {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func execute(_ request: URLRequest) async throws -> (Data, URLResponse) {
        return try await session.data(for: request)
    }
}
