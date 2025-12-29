// RegisterResponse.swift
// Traveling
// Response model for user registration

import Foundation
import Traveling

struct RegisterResponse: Decodable {
    let data: RegisterData
}

struct RegisterData: Decodable {
    let user: User
    let token: String
}
