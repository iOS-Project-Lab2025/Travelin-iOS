//
//  LoginViewModelTest.swift
//  TravelingTests
//
//  Created by Ivan Pereira on 17-12-25.
//

import Testing
@testable import Traveling

// MARK: - Login Tests

@Suite("Login Tests")
@MainActor
struct LoginTests {

    var sut: LoginViewModel

    init() {
        sut = LoginViewModel(
            authService: Services.auth,
            userService: Services.user,
            tokenManager: Services.tokenManager
        )
    }

    @Test("Valid Email", arguments: [
        ("test@test.com", true),
        ("user@domain.co", true),
        ("@test.com", false),
        ("email", false),
        ("", false)
    ])
    func test_emailIsValid(email: String, expectedResult: Bool) {
        sut.email = email
        let result = sut.validateEmail()

        #expect(result == expectedResult)

    }

    @Test("Valid Password", arguments: [
        ("123456", true),
        ("", false)
    ])
    func test_passwordIsValid(password: String, expectedResult: Bool) {
        sut.password = password
        let result = sut.validatePassword()

        #expect(result == expectedResult)
    }

    @Test("Should show email error", arguments: [
        ("", true),
        ("test", true),
        ("test@test.com", false)
    ])
    func test_showEmailError(email: String, expectedResult: Bool) {

        sut.didAttemptLogin = true
        sut.email = email

        let result = sut.shouldShowEmailError
        #expect(result  == expectedResult)

    }

    @Test("Should show password error", arguments: [
        ("", true),
        ("t", false),
        ("password", false)
    ])
    func test_showPasswordError(password: String, expectedResult: Bool) {

        sut.didAttemptLogin = true
        sut.password = password

        let result = sut.shouldShowPasswordError
        #expect(result  == expectedResult)

    }
}

// MARK: - Login Method Tests

@Suite("Login Method Tests")
@MainActor
struct LoginMethodTests {

        @Test("Login with valid credentials succeeds")
        func test_login_withValidCredentials_shouldSucceed() async {
            // Arrange
            let mockAuthService = MockAuthService()
            mockAuthService.shouldSucceed = true

            let mockTokenManager = MockTokenManager()
            let mockUserService = MockUserService()

            let sut = LoginViewModel(
                authService: mockAuthService,
                userService: mockUserService,
                tokenManager: mockTokenManager
            )

            sut.email = "test@test.com"
            sut.password = "password123"

            // Act
            await sut.login()

            // Assert
            #expect(mockAuthService.loginCallCount == 1)
            #expect(mockAuthService.lastEmail == "test@test.com")
            #expect(mockAuthService.lastPassword == "password123")
            #expect(mockTokenManager.saveTokensCalled == true)
            #expect(mockTokenManager.accessToken == "mock_access_token")
            #expect(mockTokenManager.refreshToken == "mock_refresh_token")

            // Verify final state is success
            if case .success = sut.loginState {
                // Success state confirmed
            } else {
                Issue.record("Expected loginState to be .success but was \(sut.loginState)")
            }
        }

        @Test("Login with invalid credentials fails")
        func test_login_withInvalidCredentials_shouldFail() async {
            // Arrange
            let mockAuthService = MockAuthService()
            mockAuthService.shouldThrowError = true

            let mockTokenManager = MockTokenManager()
            let mockUserService = MockUserService()

            let sut = LoginViewModel(
                authService: mockAuthService,
                userService: mockUserService,
                tokenManager: mockTokenManager
            )

            sut.email = "test@test.com"
            sut.password = "wrongpassword"

            // Act
            await sut.login()

            // Assert
            #expect(mockAuthService.loginCallCount == 1)
            #expect(mockTokenManager.saveTokensCalled == false)

            // Verify final state is failure
            if case .failure(let error) = sut.loginState {
                #expect(error is MockAuthService.MockAuthError)
            } else {
                Issue.record("Expected loginState to be .failure but was \(sut.loginState)")
            }
        }

        @Test("Login with invalid email does not call service")
        func test_login_withInvalidEmail_shouldNotCallService() async {
            // Arrange
            let mockAuthService = MockAuthService()
            let mockTokenManager = MockTokenManager()
            let mockUserService = MockUserService()

            let sut = LoginViewModel(
                authService: mockAuthService,
                userService: mockUserService,
                tokenManager: mockTokenManager
            )

            sut.email = "invalid-email"
            sut.password = "password123"

            // Act
            await sut.login()

            // Assert
            #expect(mockAuthService.loginCallCount == 0)
            #expect(mockTokenManager.saveTokensCalled == false)
            #expect(sut.didAttemptLogin == true)

            // Verify state remains idle
            if case .idle = sut.loginState {
                // Idle state confirmed
            } else {
                Issue.record("Expected loginState to be .idle but was \(sut.loginState)")
            }
        }

        @Test("Login with empty password does not call service")
        func test_login_withEmptyPassword_shouldNotCallService() async {
            // Arrange
            let mockAuthService = MockAuthService()
            let mockTokenManager = MockTokenManager()
            let mockUserService = MockUserService()

            let sut = LoginViewModel(
                authService: mockAuthService,
                userService: mockUserService,
                tokenManager: mockTokenManager
            )

            sut.email = "test@test.com"
            sut.password = ""

            // Act
            await sut.login()

            // Assert
            #expect(mockAuthService.loginCallCount == 0)
            #expect(mockTokenManager.saveTokensCalled == false)
            #expect(sut.didAttemptLogin == true)

            // Verify state remains idle
            if case .idle = sut.loginState {
                // Idle state confirmed
            } else {
                Issue.record("Expected loginState to be .idle but was \(sut.loginState)")
            }
        }

        @Test("Login sets didAttemptLogin to true")
        func test_login_shouldSetDidAttemptLogin() async {
            // Arrange
            let mockAuthService = MockAuthService()
            let mockTokenManager = MockTokenManager()
            let mockUserService = MockUserService()

            let sut = LoginViewModel(
                authService: mockAuthService,
                userService: mockUserService,
                tokenManager: mockTokenManager
            )

            sut.email = "test@test.com"
            sut.password = "password123"

            #expect(sut.didAttemptLogin == false)

            // Act
            await sut.login()

            // Assert
            #expect(sut.didAttemptLogin == true)
        }

        @Test("Login with token manager error fails")
        func test_login_whenTokenManagerFails_shouldSetFailureState() async {
            // Arrange
            let mockAuthService = MockAuthService()
            mockAuthService.shouldSucceed = true

            let mockTokenManager = MockTokenManager()
            mockTokenManager.shouldThrowError = true

            let mockUserService = MockUserService()

            let sut = LoginViewModel(
                authService: mockAuthService,
                userService: mockUserService,
                tokenManager: mockTokenManager
            )

            sut.email = "test@test.com"
            sut.password = "password123"

            // Act
            await sut.login()

            // Assert
            #expect(mockAuthService.loginCallCount == 1)
            #expect(mockTokenManager.saveTokensCalled == true)

            // Verify final state is failure
            if case .failure(let error) = sut.loginState {
                #expect(error is MockTokenManager.MockError)
            } else {
                Issue.record("Expected loginState to be .failure but was \(sut.loginState)")
            }
        }
    }
