//
//  PayloadBuilderProtocol.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 17-11-25.
//

import Foundation

/// MARK: - PayloadBuilder Protocol
///
/// Defines the required behavior for transforming an `Encodable` model
/// into raw `Data`, usually for use as the HTTP body of a network request.
///
/// This abstraction allows different encoding strategies to be implemented
/// while keeping the networking layer decoupled from encoding logic.
///
/// ## Responsibilities
/// - Provide a single method for JSON serialization of Swift models.
///
/// ## Usage Example
/// ```swift
/// struct RegisterRequest: Encodable { let username: String }
///
/// func send(builder: PayloadBuilderProtocol) {
///     let body = try? builder.buildPayload(from: RegisterRequest(username: "John"))
/// }
/// ```
///
/// ## Notes
/// - Implementations may throw errors depending on the chosen encoding strategy.
/// - Typically used inside `RequestBuilderProtocol`.
///
/// ## SeeAlso
/// - `PayloadBuilderImp`
/// - `RequestBuilderProtocol`
protocol PayloadBuilderProtocol {

    /// Serializes an `Encodable` model into raw `Data`.
    ///
    /// - Parameter model: The object to encode.
    /// - Returns: Encoded `Data`.
    /// - Throws: Any encoding error triggered by the implementation.
    func buildPayload<E: Encodable>(from model: E) throws -> Data
}
