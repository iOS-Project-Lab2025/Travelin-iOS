//
//  ErrorResponse.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 30-11-25.
//

import Foundation

// MARK: - Error Response Model
///
/// Represents the general structure of an error returned by the backend API.
/// This model is commonly decoded when the server responds with an error payload.
///
/// ## Properties
/// - `message`: A human-readable description of the error.
/// - `code`: Optional backend-specific error identifier.
/// - `details`: Optional dictionary for additional contextual information.
///
/// ## Usage Example
/// ```swift
/// let errorResponse = try decoder.decode(ErrorResponse.self, from: data)
/// print(errorResponse.message)
/// ```
///
/// ## Notes
/// - Used primarily by `NetworkServiceImp` when mapping server error responses.
/// - Complements `NetworkingError.serverError`.
///
/// ## SeeAlso
/// - `NetworkingError`
struct ErrorResponse: Decodable {
    let message: String
    let code: String?
    let details: [String: String]?
}
