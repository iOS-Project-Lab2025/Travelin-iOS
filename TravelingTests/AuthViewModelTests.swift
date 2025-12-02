//
//  AuthViewModelTests.swift
//  Traveling
//
//  Created by NVSH on 03-11-25.
//

import XCTest

// Imports the main app target ("Traveling") as "testable".
// This gives our Test target access to the app's `internal` types,
// like `TokenManaging`, `OAuthTokens`, and `AuthViewModel`.
@testable import Traveling

// MARK: - Subject Under Test (SUT)

/// A hypothetical ViewModel responsible for managing authentication logic and state.
///
/// This class demonstrates how to use the `TokenManaging` protocol for
/// Dependency Injection. By depending on the *protocol* (the "contract")
/// instead of a concrete class, we can "inject" a `MockTokenManager`
/// during tests.
///
/// (In a real project, this class would be in the main app target,
/// not in the Test target).
class AuthViewModel: ObservableObject {

    // MARK: - State Properties

    /// The current authentication state, published to the View.
    @Published var isAuthenticated = false

    /// An error message to display to the user, published to the View.
    @Published var errorMessage: String?

    // MARK: - Dependencies

    /// Our dependency, conforming to the `TokenManaging` protocol.
    /// This could be the "real" `KeychainTokenManager` or the "fake" `MockTokenManager`.
    private let tokenManager: TokenManaging

    // MARK: - Initializer

    /// Injects the `TokenManaging` dependency and sets the initial auth state.
    ///
    /// It checks if a token *already* exists (e.g., from a previous session)
    /// to determine the initial `isAuthenticated` state.
    init(tokenManager: TokenManaging) {
        self.tokenManager = tokenManager
        self.isAuthenticated = tokenManager.getAccessToken() != nil
    }

    // MARK: - Business Logic

    /// Attempts to log the user in by saving their tokens.
    ///
    /// This is the core "business logic" we need to test:
    /// 1. On success, it updates the state to `isAuthenticated = true`.
    /// 2. On failure (e.g., Keychain write error), it catches the error,
    ///    sets `isAuthenticated = false`, and provides a user-facing error message.
    func login(tokens: OAuthTokens) {
        do {
            try tokenManager.saveTokens(tokens)
            self.isAuthenticated = true
            self.errorMessage = nil
        } catch {
            self.isAuthenticated = false
            self.errorMessage = "Failed to save session. Please try again."
        }
    }

    /// Logs the user out by clearing tokens and resetting the state.
    func logout() {
        tokenManager.clearTokens()
        self.isAuthenticated = false
    }
}

// MARK: - Test Case

/// The `XCTestCase` responsible for verifying all business logic and state
/// changes within the `AuthViewModel`.
class AuthViewModelTests: XCTestCase {

    // MARK: - Properties

    /// The "Subject Under Test" (SUT). This is the instance of the
    /// `AuthViewModel` that we are testing in each function.
    var viewModel: AuthViewModel!

    /// The "Mock Object" (a "fake" token manager) that we will
    /// inject into our `viewModel`.
    var mockTokenManager: MockTokenManager!

    // MARK: - Test Lifecycle

    /// This function is called *before* every single test function runs.
    ///
    /// We use it to create a "clean slate" for each test. By creating a
    /// *new* mock and a *new* view model every time, we ensure that
    /// one test cannot affect or "leak" state into another.
    /// This is known as **Test Isolation**.
    override func setUp() {
        super.setUp()
        mockTokenManager = MockTokenManager()
        viewModel = AuthViewModel(tokenManager: mockTokenManager)
    }

    /// This function is called *after* every single test function runs.
    ///
    /// We use it to clean up the objects we created in `setUp()` to
    /// prevent memory leaks.
    override func tearDown() {
        viewModel = nil
        mockTokenManager = nil
        super.tearDown()
    }

    // MARK: - Test Cases

    /// Tests that the ViewModel correctly initializes to a "logged out"
    /// state when no pre-existing token is found.
    func test_init_whenTokenManagerHasNoToken_isAuthenticatedIsFalse() {
        // Given: The `mockTokenManager` is empty (created in `setUp`).
        // When: The `viewModel` is initialized (created in `setUp`).

        // Then: The user's state should be "not authenticated".
        XCTAssertFalse(viewModel.isAuthenticated, "The user should not be authenticated if no token exists.")
    }

    /// Tests that the ViewModel correctly initializes to a "logged in"
    /// state if a token *already* exists from a previous session.
    func test_init_whenTokenManagerHasToken_isAuthenticatedIsTrue() {
        // Given: A new mock that is "pre-filled" with an existing token.
        let mockWithToken = MockTokenManager()
        mockWithToken.accessToken = "existing_token_123"

        // When: A new ViewModel is initialized *with that specific mock*.
        let vm = AuthViewModel(tokenManager: mockWithToken)

        // Then: The ViewModel's state should immediately be "authenticated".
        XCTAssertTrue(vm.isAuthenticated, "The user should be authenticated if a token already exists.")
    }

    /// Tests the "Happy Path" for the `login` function.
    /// Verifies that state is updated and the mock is called correctly.
    func test_login_whenSaveIsSuccessful_isAuthenticatedIsTrueAndTokensAreSaved() throws {
        // Given: A new set of tokens to be saved.
        let newTokens = OAuthTokens(accessToken: "access123", refreshToken: "refresh465")

        // When: The `login` function is called.
        viewModel.login(tokens: newTokens)

        // Then (Part 1): The ViewModel's state should be updated correctly.
        XCTAssertTrue(viewModel.isAuthenticated)
        XCTAssertNil(viewModel.errorMessage)

        // Then (Part 2): We "spy" on the mock to verify it was called.
        XCTAssertTrue(mockTokenManager.saveTokensCalled)

        // Then (Part 3): We "spy" on the mock to verify the *correct data* was saved.
        XCTAssertEqual(mockTokenManager.accessToken, "access123")
        XCTAssertEqual(mockTokenManager.refreshToken, "refresh465")
    }

    /// Tests the "Sad Path" for the `login` function.
    /// Verifies that the ViewModel correctly handles a failure from the manager.
    func test_login_whenSaveFails_isAuthenticatedIsFalseAndErrorIsSet() {
        // Given: A new set of tokens.
        let newTokens = OAuthTokens(accessToken: "access123", refreshToken: nil)

        // And: We "stub" the mock, telling it to *simulate an error*
        // when `saveTokens` is called.
        mockTokenManager.shouldThrowError = true

        // When: The `login` function is called.
        viewModel.login(tokens: newTokens)

        // Then (Part 1): The ViewModel's state should reflect the failure.
        XCTAssertFalse(viewModel.isAuthenticated)
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.errorMessage, "Failed to save session. Please try again.")

        // Then (Part 2): We "spy" on the mock to verify the tokens were *not* saved.
        XCTAssertNil(mockTokenManager.accessToken)
    }

    /// Tests the `logout` function.
    /// Verifies that state is cleared and the manager is called correctly.
    func test_logout_ShouldClearTokensAndSetIsAuthenticatedFalse() {
        // Given: A user who is *already* logged in
        // (We manually set the mock's state and re-create the VM).
        mockTokenManager.accessToken = "token_to_delete"
        viewModel = AuthViewModel(tokenManager: mockTokenManager)

        // Pre-condition: Verify the user *is* logged in before the test.
        XCTAssertTrue(viewModel.isAuthenticated, "Pre-condition failed: ViewModel should be authenticated.")

        // When: The `logout` function is called.
        viewModel.logout()

        // Then (Part 1): The ViewModel's state should be "not authenticated".
        XCTAssertFalse(viewModel.isAuthenticated)

        // Then (Part 2): We "spy" on the mock to verify `clearTokens` was called.
        XCTAssertTrue(mockTokenManager.clearTokensCalled)

        // Then (Part 3): We "spy" on the mock to verify the token was *actually* deleted.
        XCTAssertNil(mockTokenManager.getAccessToken())
    }
}
