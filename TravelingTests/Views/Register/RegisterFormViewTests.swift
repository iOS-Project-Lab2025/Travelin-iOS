//
//  RegisterFormViewTests.swift
//  Traveling
//
//  Created by Ignacio Alvarado on 09-12-25.
//

import XCTest
import SwiftUI
import ViewInspector
import TravelinDesignSystem
@testable import Traveling

// MARK: - ViewInspector Extension
/// Extends RegisterFormView to allow inspection of its internal hierarchy.
extension RegisterFormView: Inspectable { }

// MARK: - Test Suite
// Note: We apply @MainActor to the entire class.
// This allows initializing the ViewModel synchronously without using Task { }.
@MainActor
final class RegisterFormViewTests: XCTestCase {

    // MARK: - Properties

    private var viewModel: RegisterViewModel!

    // MARK: - Setup & Teardown

    override func setUp() {
        super.setUp()
        // Initialize the ViewModel directly.
        // Since the test class runs on MainActor, this is safe and synchronous.
        viewModel = RegisterViewModel()
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    // MARK: - Tests: Initial State

    func test_createAccountButton_isDisabled_whenFormIsEmpty() throws {
        // 1. Arrange
        let view = RegisterFormView(registerViewModel: viewModel)

        // 2. Act
        // Find the button. ViewInspector searches for a button containing this text/label.
        let button = try view.inspect().find(button: "register.createAccountButtonTitle".localized)

        // 3. Assert
        XCTAssertTrue(button.isDisabled(), "The button should be disabled when the form is empty.")
    }

    // MARK: - Tests: Validation Logic

    func test_createAccountButton_isEnabled_whenFormIsValid() throws {
        // 1. Arrange
        let view = RegisterFormView(registerViewModel: viewModel)

        // Fill the form (Direct access since we are on MainActor)
        viewModel.firstName = "Ignacio"
        viewModel.lastName = "Alvarado"
        viewModel.phone = "912345678"
        viewModel.email = "test@gmail.com"
        viewModel.password = "Password123!" // Meets strength requirements

        // 2. Act
        let button = try view.inspect().find(button: "register.createAccountButtonTitle".localized)

        // 3. Assert
        XCTAssertFalse(button.isDisabled(), "The button should be enabled when the form is valid.")
    }

    // MARK: - Tests: Loading State

    func test_progressView_isDisplayed_whenStateIsLoading() throws {
        // 1. Arrange
        let view = RegisterFormView(registerViewModel: viewModel)

        // Change state to loading
        viewModel.state = .loading

        // 2. Act
        // Check if a ProgressView exists in the view hierarchy
        let spinner = try? view.inspect().find(ViewType.ProgressView.self)

        // 3. Assert
        XCTAssertNotNil(spinner, "A spinner (ProgressView) should appear when loading.")
    }

    // MARK: - Tests: Error Handling

    func test_errorMessage_isDisplayed_whenStateIsFailure() throws {
        // 1. Arrange
        let view = RegisterFormView(registerViewModel: viewModel)
        let errorMsg = "Crazy server error"

        // Force the error state
        let error = NSError(domain: "Test", code: 400, userInfo: [NSLocalizedDescriptionKey: errorMsg])
        viewModel.state = .failure(error)

        // 2. Act
        // Search for a Text view containing exactly the error message
        let text = try view.inspect().find(text: errorMsg)

        // 3. Assert
        XCTAssertEqual(try text.string(), errorMsg)
    }
}
