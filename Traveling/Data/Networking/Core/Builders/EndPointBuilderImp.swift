//
//  EndPointBuilder.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 18-11-25.
//

import Foundation

struct EndPointBuilderImp: EndPointBuilderProtocol {
    
    private let baseURL: URL    // <-- URL

    init(baseURL: String) throws {
        
        guard let url = URL(string: baseURL) else {
            throw NetworkingError.invalidURL(URLError(.badURL, userInfo: [
                NSLocalizedDescriptionKey: "Error with BaseURL"
            ]))
        }
        guard url.scheme != nil else {
            throw NetworkingError.invalidURL(URLError(.badURL, userInfo: [
                NSLocalizedDescriptionKey: "Missing URL scheme"
            ]))
        }
        guard url.host != nil else {
            throw NetworkingError.invalidURL(URLError(.badURL, userInfo: [
                NSLocalizedDescriptionKey: "Missing URL host"
            ]))
        }
        self.baseURL = url
    }
    func buildURL(from endPoint: EndPointProtocol) throws -> URL {
        var components = URLComponents()
        components.scheme = self.baseURL.scheme
        components.host = self.baseURL.host
        components.port = self.baseURL.port
        components.path = self.baseURL.path + endPoint.path
        components.queryItems = endPoint.queryItems

        guard let url = components.url else {
            throw NetworkingError.invalidURL(URLError(.badURL))
        }
        NetworkDebug.lastURL = url.absoluteString
        return url
    }
}


enum NetworkDebug {
    static var lastURL: String?
}
