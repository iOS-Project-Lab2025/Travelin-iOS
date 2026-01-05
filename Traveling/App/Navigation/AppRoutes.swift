//
//  AppRoutes.swift
//  Traveling
//
//  Created by Ivan Pereira on 19-11-25.
//

import Foundation

enum AppRoutes: Hashable {
    case initial
    case home
    case onBoarding
    case authentication(AuthenticationEntry)
    case profile
    case booking
    case wishlist
}

enum AuthenticationEntry {
    case login
    case register
}
