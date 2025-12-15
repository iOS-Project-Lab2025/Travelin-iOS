//
//  LoginState.swift
//  Traveling
//
//  Created by Ivan Pereira on 15-12-25.
//

import Foundation

enum LoginState {
    case idle
    case loading
    case success
    case failure(Error)
}
