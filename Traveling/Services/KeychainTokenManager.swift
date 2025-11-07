//
//  KeychainTokenManager.swift
//  Traveling
//
//  Created by NVSH on 29-10-25.
//
import Foundation
import KeychainAccess
import OSLog

/// The concrete implementation of the `TokenManaging` protocol.
///
/// This class is responsible for all interactions with the device's secure Keychain.
/// It encapsulates the `KeychainAccess` library, ensuring that the rest of the
/// application is completely decoupled from the specific implementation details
/// of secure storage. This is the class used in the "live" production app.
class KeychainTokenManager: TokenManaging {

    // MARK: - Properties
    
    /// A private, constant key for storing the access token in the Keychain.
    private let accessTokenKey = "app.accessToken"
    
    /// A private, constant key for storing the refresh token in the Keychain.
    private let refreshTokenKey = "app.refreshtoken"
    
    /// The instance of the Keychain library, configured for this app's service.
    private let keychain: Keychain
    
    /// A dedicated logger for this manager for easier debugging.
    /// (Reemplaza los `print` por esto para un código de producción)
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.yourapp.default",
                                category: "KeychainTokenManager")

    // MARK: - Initializer
    
    /// Initializes the token manager.
    /// - Parameter serviceIdentifier: A unique string to isolate this app's
    ///   Keychain items. The best practice is to use the app's bundle identifier.
    init(serviceIdentifier: String = Bundle.main.bundleIdentifier ?? "com.yourapp.default") {
        self.keychain = Keychain(service: serviceIdentifier)
    }

    // MARK: - TokenManaging Conformance
    
    /// Securely saves tokens to the Keychain.
    ///
    /// This function will attempt to save both tokens. If the `refreshToken`
    /// is `nil` in the provided `tokens` object, it will actively remove
    /// any existing refresh token from the Keychain.
    ///
    /// - Throws: Re-throws any error from the `KeychainAccess` library
    ///   if the write operation fails.
    func saveTokens(_ tokens: OAuthTokens) throws {
        do {
            // 1. Save the access token
            try keychain.set(tokens.accessToken, key: accessTokenKey)
            
            // 2. Handle the refresh token (it's optional)
            if let refreshToken = tokens.refreshToken {
                // If it exists, save it
                try keychain.set(refreshToken, key: refreshTokenKey)
            } else {
                // If it's nil, remove any old refresh token to prevent mismatches
                try keychain.remove(refreshTokenKey)
            }
            
            logger.info("Tokens saved to Keychain successfully.")
            
        } catch let error {
            // If any 'try' fails, log the error and propagate it
            logger.error("Error saving tokens to Keychain: \(error.localizedDescription)")
            throw error
        }
    }
    
    /// Retrieves the access token from the Keychain.
    ///
    /// Note the use of `try?`. The `keychain.getString` function can throw an
    /// error (e.g., if the item is not found). We deliberately convert this
    /// throwing call into an optional `String?` to match the non-throwing
    /// protocol requirement.
    /// - Returns: The token string, or `nil` if not found or if an error occurs.
    func getAccessToken() -> String? {
        return try? keychain.getString(accessTokenKey)
    }
    
    /// Retrieves the refresh token from the Keychain.
    /// - Returns: The token string, or `nil` if not found or if an error occurs.
    func getRefreshToken() -> String? {
        return try? keychain.getString(refreshTokenKey)
    }
    
    /// Deletes all tokens from the Keychain (a "fire-and-forget" operation).
    ///
    /// As defined by the `TokenManaging` protocol, this function does not
    /// throw errors. It catches and logs any potential errors (e.g., trying
    /// to delete items that don't exist), but it does not propagate them,
    /// as the desired end-state (no tokens) is achieved regardless.
    func clearTokens() {
        do {
            try keychain.remove(accessTokenKey)
            try keychain.remove(refreshTokenKey)
            logger.info("Tokens cleared from Keychain.")
        } catch let error {
            // Log the error for debugging, but don't disrupt the logout flow.
            logger.warning("Error clearing tokens (this might be fine): \(error.localizedDescription)")
        }
    }
    
}
