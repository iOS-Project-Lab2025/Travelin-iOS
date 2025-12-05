//
//  TokenManaging.swift
//  Traveling
//
//  Created by NVSH on 29-10-25.
//

import Foundation

/// Defines the "contract" for any service that needs to manage
/// authentication tokens.
///
/// By using a protocol, we can easily swap out the implementation
/// (e.g., use a real `KeychainTokenManager` or a `MockTokenManager` for testing)
/// without changing any of the code that uses it.
protocol TokenManaging {

    /// Securely saves the provided tokens.
    /// - Parameter tokens: The `OAuthTokens` object to be saved.
    /// - Throws: An error if the saving operation fails (e.g., a Keychain I/O error).
    func saveTokens(_ tokens: OAuthTokens) throws

    /// Retrieves the currently saved access token.
    /// - Returns: The access token `String`, or `nil` if it's not found.
    func getAccessToken() -> String?

    /// Retrieves the currently saved refresh token.
    /// - Returns: The refresh token `String`, or `nil` if it's not found.
    func getRefreshToken() -> String?

    /// Deletes all saved tokens from secure storage.
    ///
    /// This is typically used for logging out. It's a "fire-and-forget"
    /// operation and does not throw an error if the tokens don't exist.
    func clearTokens()
}
