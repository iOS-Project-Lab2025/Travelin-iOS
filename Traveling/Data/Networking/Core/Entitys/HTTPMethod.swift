//
//  HTTPMethod.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 17-11-25.
//

import Foundation

// MARK: - HTTP Method Enumeration
///
/// Defines the supported HTTP methods for network requests.
/// Each case exposes its correct uppercase raw value, fully compatible with `URLRequest`.
///
/// ## Supported Methods
/// - GET
/// - POST
/// - PUT
/// - DELETE
/// - PATCH
///
/// ## Usage Example
/// ```swift
/// struct LoginEndpoint: EndPointProtocol {
///     var method: HTTPMethod { .post }
/// }
/// ```
///
/// ## Notes
/// - Raw values match the HTTP specification.
/// - Used by `RequestBuilderImp` to populate `request.httpMethod`.
enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}
