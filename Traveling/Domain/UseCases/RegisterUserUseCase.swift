// RegisterUserUseCase.swift
// Traveling
// Use case for user registration

import Foundation

protocol RegisterUserUseCaseProtocol {
    func execute(email: String, password: String, firstName: String, lastName: String, phone: String) async throws -> RegisterResponse
}

final class RegisterUserUseCase: RegisterUserUseCaseProtocol {
    private let authService: AuthService

    init(authService: AuthService) {
        self.authService = authService
    }

    func execute(email: String, password: String, firstName: String, lastName: String, phone: String) async throws -> RegisterResponse {
        return try await authService.register(email: email, password: password, firstName: firstName, lastName: lastName, phone: phone)
    }
}
