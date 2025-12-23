// User.swift
// Traveling
// User model for registration response

import Foundation

struct User: Codable, Identifiable, Equatable {
    let id: Int
    let email: String
    let firstName: String?
    let lastName: String?
    let phone: String?
    let createdAt: Date?
    let updatedAt: Date?
}
