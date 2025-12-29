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
        guard baseURL.scheme != nil, baseURL.host != nil else {
            fatalError("Invalid base URL")
        }
        self.baseURL = baseURL
    }

    func buildURL(from endPoint: EndPointProtocol) throws -> URL {
        var components = URLComponents()
        components.scheme = baseURL.scheme
        components.host = baseURL.host
        components.port = baseURL.port
        components.path = baseURL.path + endPoint.path
        components.queryItems = endPoint.queryItems

        guard let url = components.url else {
            throw URLError(.badURL)
        }
        NetworkDebug.lastURL = url.absoluteString
        return url
    }
}
