//
//  RegisterState.swift
//  Traveling
//
//  Created by NASH on 27-12-25.
//

import Foundation

enum RegisterState: Equatable {
    case idle
    case loading
    case success
    case failure(Error)

    static func == (lhs: RegisterState, rhs: RegisterState) -> Bool {
            switch (lhs, rhs) {
            case (.idle, .idle): return true
            case (.loading, .loading): return true
            case (.success, .success): return true

            case (.failure(let lhsError), .failure(let rhsError)):
                // Comparamos la descripción del error ya que Error genérico no es Equatable
                return lhsError.localizedDescription == rhsError.localizedDescription

            default:
                return false
            }
        }
}
