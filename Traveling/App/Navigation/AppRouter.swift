//
//  AppCoordinator.swift
//  Traveling
//
//  Created by Ivan Pereira on 18-11-25.
//

import Foundation
import SwiftUI

@Observable
final class AppRouter {

    static let shared = AppRouter()
    private init() {}

    // Active main route
    var activeRoute: AppRoutes = .home

    // To go to one of the main routes
    func goTo(_ route: AppRoutes) {
        activeRoute = route
    }
}

extension EnvironmentValues {
    @Entry var appRouter: AppRouter = .shared
}
