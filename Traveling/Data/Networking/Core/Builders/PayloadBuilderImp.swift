//
//  PayloadBuilderImp.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 18-11-25.
//

import Foundation

// MARK: - PayloadBuilder Implementation
///
/// `PayloadBuilderImp` is responsible for encoding any `Encodable` model
/// into JSON `Data`, which is later used as the HTTP body of a request.
///
/// This component centralizes JSON encoding behavior, ensuring a consistent
/// serialization strategy across the app.
///
/// ## Responsibilities
/// - Encode Swift `Encodable` models into JSON data.
/// - Configure a `JSONEncoder` instance (default: `convertToSnakeCase`).
/// - Throw clear and consistent errors in case of encoding failure.
///
/// ## Usage Example
/// ```swift
/// struct LoginRequest: Encodable {
///     let email: String
///     let password: String
/// }
///
/// let builder = PayloadBuilderImp()
/// let data = try builder.buildPayload(from: LoginRequest(email: "a@mail.com", password: "1234"))
/// ```
///
/// ## Error Handling
/// - Throws `NetworkingError.encodingFailed` when serialization fails.
///
/// ## Notes
/// - The encoder can be customized by injecting an external `JSONEncoder`.
/// - Commonly used by `RequestBuilderImp` when the request has a body.
///
/// ## SeeAlso
/// - `PayloadBuilderProtocol`
/// - `NetworkingError`
struct PayloadBuilderImp: PayloadBuilderProtocol {

    private let encoder: JSONEncoder

    /// Initializes the payload builder with a configurable `JSONEncoder`.
    ///
    /// - Parameter encoder: Allows injecting a custom encoder. Defaults to `JSONEncoder()`
    ///   with `.convertToSnakeCase` applied.
    init(encoder: JSONEncoder = JSONEncoder()) {
        self.encoder = encoder
        self.encoder.keyEncodingStrategy = .convertToSnakeCase
    }

    /// Encodes an `Encodable` model into JSON data.
    ///
    /// - Parameter model: Any value conforming to `Encodable`.
    /// - Returns: Serialized JSON `Data`.
    /// - Throws: `NetworkingError.encodingFailed` if encoding fails.
    func buildPayload<E: Encodable>(from model: E) throws -> Data {
        do {
            let data = try self.encoder.encode(model)
            return data
        } catch let error as EncodingError {
            throw NetworkingError.encodingFailed(error)
        }
    }
}
