//
//  EndPointBuilder.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 18-11-25.
//

import Foundation

struct EndPointBuilder: EndPointBuilderProtocol {
    private let baseURL: URL    // <-- URL

        init(baseURL: URL) {
            self.baseURL = baseURL
        }

        func buildURL(from endPoint: EndPoint) throws -> URL {
            var components = URLComponents()
            components.scheme = baseURL.scheme
            components.host = baseURL.host
            components.path = endPoint.path
            components.queryItems = endPoint.queryItems

            guard let url = components.url else {
                throw URLError(.badURL)
            }
            return url
        }
}
