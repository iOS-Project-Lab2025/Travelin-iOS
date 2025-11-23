//
//  AppCoordinator.swift
//  Traveling
//
//  Created by Ivan Pereira on 18-11-25.
//

import Foundation
import SwiftUI

enum AppRouter {

    // MARK: Singleton main router
    @Observable
    final class Main {

        static let shared = Main()
        private init() {}

        // Active main route
        var path: AppRoutes = .home

        // To go to one of the main routes
        func goTo(_ route: AppRoutes) {
            path = route
        }
    }

    // MARK: - Allows you to freely navigate between routes using a navigation stack
    @Observable
    final class PathRouter<Route: Hashable> {
        var path = NavigationPath()

        func goTo(_ destination: Route) {
            path.append(destination)
        }

        func previous() {
            guard path.count > 0 else { return }
            path.removeLast()
        }

        func reset() {
            path = NavigationPath()
        }

    }

    // MARK: - Router with steps
    @Observable
    final class FlowRouter<Route: Hashable> {
        private let flow: [Route]

        var path = NavigationPath() {
            didSet { syncCurrentStep() }
        }

        private(set) var currentStep = 0

        init(flow: [Route]) {
            self.flow = flow
        }

        private var canGoNext: Bool { currentStep < flow.count - 1 }
        private var canGoBack: Bool { currentStep > 0 }

        func next() {
            guard canGoNext else { return }
            path.append(flow[currentStep + 1])
        }

        func previous() {
            guard canGoBack else { return }
            path.removeLast()
        }

        func reset() {
            path = NavigationPath()
        }

        private func syncCurrentStep() {
            currentStep = min(path.count, flow.count - 1)
        }
    }

}

extension EnvironmentValues {
    @Entry var appRouter = AppRouter.Main.shared
}
