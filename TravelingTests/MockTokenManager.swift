//
//  MockTokenManager.swift
//  Traveling
//
//  Created by NVSH on 03-11-25.
//
import Foundation

// Imports the main app target ("Traveling") as "testable".
// This gives our Test target access to the app's `internal` types,
// like `TokenManaging` and `OAuthTokens`.
@testable import Traveling

/// A "Mock" (or "Fake") implementation of the `TokenManaging` protocol
/// used exclusively for unit testing.
///
/// This class **does not** interact with the device Keychain. It simulates
/// all behavior in-memory using simple variables.
///
/// It provides two key functions for testing:
/// 1.  **Spying:** Public properties (e.g., `accessToken`, `saveTokensCalled`)
///     that tests can "spy" on to verify state and behavior.
/// 2.  **Stubbing:** Control properties (e.g., `shouldThrowError`) that
///     allow tests to "stub" or force specific behaviors, like failure.
class MockTokenManager: TokenManaging {
    
    // MARK: - Spy Properties (State Storage)
    
    /// In-memory storage for the access token. Tests can read this
    /// directly to assert that the correct value was saved.
    var accessToken: String?
    
    /// In-memory storage for the refresh token.
    var refreshToken: String?
    
    // MARK: - Spy Properties (Behavior Tracking)
    
    /// A "spy" flag that tracks if `saveTokens` was called.
    var saveTokensCalled = false
    
    /// A "spy" flag that tracks if `clearTokens` was called.
    var clearTokensCalled = false
    
    // MARK: - Stub Properties (Behavior Simulation)
    
    /// A "stub" flag. When set to `true`, the `saveTokens` function
    /// will throw `MockError.simulatedSaveError` to test failure paths.
    var shouldThrowError = false
    
    /// A custom error type used by this mock to simulate failures.
    enum MockError: Error, Equatable {
        case simulatedSaveError
    }
    
    // MARK: - TokenManaging Conformance
    
    /// Simulates saving tokens to in-memory variables.
    ///
    /// This function will set `saveTokensCalled` to `true` and will
    /// throw an error if `shouldThrowError` is `true`.
    func saveTokens(_ tokens: OAuthTokens) throws {
        saveTokensCalled = true
        
        if shouldThrowError {
            throw MockError.simulatedSaveError
        }
        
        // Save to in-memory "spy" properties
        self.accessToken = tokens.accessToken
        self.refreshToken = tokens.refreshToken
    }
    
    /// Simulates retrieving the access token from in-memory storage.
    func getAccessToken() -> String? {
        return accessToken
    }
    
    /// Simulates retrieving the refresh token from in-memory storage.
    func getRefreshToken() -> String? {
        return refreshToken
    }
    
    /// Simulates clearing tokens from in-memory storage.
    func clearTokens() {
        clearTokensCalled = true
        self.accessToken = nil
        self.refreshToken = nil
    }
    
    // MARK: - Test Utilities
    
    /// Resets the mock to its default, "clean" state.
    ///
    /// This is crucial for test isolation and should be called in the
    /// `setUp()` method of any `XCTestCase` that uses this mock.
    func reset() {
        accessToken = nil
        refreshToken = nil
        saveTokensCalled = false
        clearTokensCalled = false
        shouldThrowError = false
    }
}
