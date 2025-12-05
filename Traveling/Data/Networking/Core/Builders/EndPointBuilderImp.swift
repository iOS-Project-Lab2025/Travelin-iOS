//
//  EndPointBuilderImp.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 18-11-25.
//

import Foundation

// MARK: - EndPointBuilder Implementation
///
/// `EndPointBuilderImp` is responsible for constructing complete URLs based on a base URL
/// and endpoint definitions. It validates the provided base URL and ensures that
/// generated URLs are structurally correct.
///
/// ## Responsibilities
/// - Validate the base URL (scheme and host required)
/// - Construct URLs using:
///   - base scheme
///   - base host
///   - base port
///   - base path + endpoint path
///   - query items from the endpoint
///
/// ## Notes
/// - Any failure in URL generation results in `NetworkingError.invalidURL`.
/// - The last generated URL is stored in `NetworkDebug.lastURL` for debugging.
///
/// ## Example
/// ```swift
/// let builder = try EndPointBuilderImp(baseURL: "https://api.example.com")
/// let url = try builder.buildURL(from: MyEndpoint.users)
/// ```
///
struct EndPointBuilderImp: EndPointBuilderProtocol {

    private let baseURL: URL    // Base URL used for building all endpoints

    /// Initializes the builder and validates the given base URL string.
    ///
    /// - Parameter baseURL: A string representing the base API URL.
    /// - Throws: `NetworkingError.invalidURL` when the base URL is malformed.
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

    /// Builds the final URL for the specified endpoint.
    ///
    /// - Parameter endPoint: The endpoint definition containing path and query parameters.
    /// - Returns: A fully constructed `URL`.
    /// - Throws: `NetworkingError.invalidURL` if the resulting URL is invalid.
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

        // Stores the last successfully generated URL for debugging
        NetworkDebug.lastURL = url.absoluteString

        return url
    }
}

/// Debug helper used to track the last generated URL.
/// Useful for logging or debugging network behavior.
enum NetworkDebug {
    static var lastURL: String?
}
