//
//  NetworkService.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 19-11-25.
//

import Foundation

final class NetworkService: NetworkServiceProtocol {
    private let client: NetworkClientProtocol
    private let requestBuilder: RequestBuilderProtocol
    init(client: NetworkClientProtocol,
         requestBuilder: RequestBuilderProtocol) {
        self.client = client
        self.requestBuilder = requestBuilder
    }
    func execute<T: Decodable>(
        _ endPoint: any EndPointProtocol,
        responseType: T.Type,
        body: Encodable? = nil
    ) async throws -> T {
        let request = try requestBuilder.buildRequest(from: endPoint, body: body)
        let (data, response) = try await client.execute(request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw DecodingError.valueNotFound(T.self, DecodingError.Context(codingPath: [], debugDescription: "Error decoding"))
        }
        guard 200...299 ~= httpResponse.statusCode else {
            throw DecodingError.valueNotFound(T.self, DecodingError.Context(codingPath: [], debugDescription: "Error decoding"))
        }
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(T.self, from: data)
    }

}
