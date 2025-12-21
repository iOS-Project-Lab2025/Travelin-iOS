// RegisterRequest.swift
// Traveling
// Request model for user registration

import Foundation

struct RegisterRequest: Encodable {
    let email: String
    let password: String
    let firstName: String
    let lastName: String
    let phone: String
}
