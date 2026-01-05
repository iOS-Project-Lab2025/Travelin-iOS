//
//  AppCoordinator.swift
//  Traveling
//
//  Created by Ivan Pereira on 18-11-25.
//

import Foundation
import SwiftUI

/// A namespace for the application's navigation system.
///
/// `AppRouter` serves as a container for the different routing mechanisms used in the app.
/// It provides a centralized structure for managing navigation flows.
///
/// - SeeAlso:
///   - ``Main``: The singleton router for top-level navigation.
///   - ``PathRouter``: A stack-based router for flexible navigation.
///   - ``FlowRouter``: A step-based router for linear flows.
enum AppRouter {

    // MARK: Singleton main router
    /// The main router for the application, handling top-level navigation.
    ///
    /// This singleton manages the root level navigation of the app, allowing switching between
    /// major sections or tabs (e.g., Home, Profile, Booking).
    ///
    /// ### Usage Example
    ///
    /// 1. **Access via Environment**:
    /// ```swift
    /// struct ContentView: View {
    ///     @Environment(\.appRouter) private var router
    ///
    ///     var body: some View {
    ///         TabView(selection: Bindable(router).path) {
    ///             HomeView()
    ///                 .tag(AppRoutes.home)
    ///             ProfileView()
    ///                 .tag(AppRoutes.profile)
    ///         }
    ///     }
    /// }
    /// ```
    ///
    /// 2. **Switch Routes**:
    /// ```swift
    /// Button("Go Home") {
    ///     // Via singleton
    ///     AppRouter.Main.shared.goTo(.home)
    ///
    ///     // Or via environment
    ///     router.goTo(.home)
    /// }
    /// ```
    @Observable
    final class Main {

        private var onBoardingComplete: (() -> Void)?
        static let shared = Main()
        private init() {
            path = UserDefaults.standard.bool(forKey: "onboardingSeen") ? .home : .onBoarding
        }

        // Active main route
        var path: AppRoutes = .onBoarding

        // To go to one of the main routes
        func goTo(_ route: AppRoutes) {
            path = route
        }

        func completeOnboarding() {
            UserDefaults.standard.set(true, forKey: "onboardingSeen")
            path = .home
        }

    }

    // MARK: - Allows you to freely navigate between routes using a navigation stack
    /// A router that manages a stack-based navigation path.
    ///
    /// Use `PathRouter` when you need standard push/pop navigation behavior.
    /// It wraps a `NavigationPath` and provides methods to append or remove destinations.
    ///
    /// - Generic Parameter `Route`: An enum conforming to `Hashable` that defines the possible destinations.
    ///
    /// ### Usage Example
    ///
    /// 1. **Define Routes**:
    /// ```swift
    /// enum ProfileRoutes: Hashable {
    ///     case userProfile
    ///     case editUserProfile
    ///     case settings
    /// }
    /// ```
    ///
    /// 2. **Instantiate in Parent View**:
    /// ```swift
    /// struct ProfileView: View {
    ///     @State private var router = AppRouter.PathRouter<ProfileRoutes>()
    ///
    ///     var body: some View {
    ///         NavigationStack(path: $router.path) {
    ///             UserProfileView()
    ///                 .navigationDestination(for: ProfileRoutes.self) { route in
    ///                     switch route {
    ///                     case .userProfile: UserProfileView()
    ///                     case .editUserProfile: EditProfileView()
    ///                     case .settings: SettingsView()
    ///                     }
    ///                 }
    ///         }
    ///         .environment(router)
    ///     }
    ///     @ViewBuilder
    ///     private func destinationView(for route: ProfileRoutes) -> some View {
    ///          switch route {
    ///          case .editUserProfile:
    ///          ProfileEditView(userId: userId)
    ///
    ///          case .userProfile:
    ///          UserProfileView(userId: userId)
    ///          }
    ///      }
    /// }
    /// ```
    ///
    /// 3. **Consume in Child View**:
    /// ```swift
    /// struct UserProfileView: View {
    ///     @Environment(AppRouter.PathRouter<ProfileRoutes>.self) private var router
    ///
    ///     var body: some View {
    ///         Button("Edit Profile") {
    ///             router.goTo(.editUserProfile)
    ///         }
    ///     }
    /// }
    /// ```
    @Observable
    final class PathRouter<Route: Hashable> {
        var path = NavigationPath()

        /// Navigates to a specific destination by appending it to the path.
        /// - Parameter destination: The route to navigate to.
        func goTo(_ destination: Route) {
            path.append(destination)
        }

        /// Removes the last destination from the path, effectively going back one step.
        func previous() {
            guard path.count > 0 else { return }
            path.removeLast()
        }

        /// Resets the navigation path to its initial state (empty).
        func reset() {
            path = NavigationPath()
        }

    }

    // MARK: - Router with steps
    /// A router designed for sequential flows or wizards.
    ///
    /// Use `FlowRouter` when you have a predefined sequence of steps (e.g., a booking flow or onboarding).
    /// It enforces a linear progression but allows moving back and forth within the defined flow.
    ///
    /// - Generic Parameter `Route`: An enum conforming to `Hashable` that defines the steps in the flow.
    ///
    /// ### Usage Example
    ///
    /// 1. **Define Routes**:
    /// ```swift
    /// enum BookingRoutes: Hashable {
    ///     case selectPlace
    ///     case selectDate
    ///     case confirm
    /// }
    /// ```
    ///
    /// 2. **Instantiate with Flow Sequence**:
    /// ```swift
    /// struct BookingView: View {
    ///     @State private var router = AppRouter.FlowRouter<BookingRoutes>(flow: [
    ///         .selectPlace,
    ///         .selectDate,
    ///         .confirm
    ///     ])
    ///
    ///     var body: some View {
    ///         NavigationStack(path: $router.path) {
    ///             SelectPlaceView()
    ///                 .navigationDestination(for: BookingRoutes.self) { route in
    ///                     switch route {
    ///                     case .selectPlace: SelectPlaceView()
    ///                     case .selectDate: SelectDateView()
    ///                     case .confirm: ConfirmView()
    ///                     }
    ///                 }
    ///         }
    ///         .environment(router)
    ///     }
    ///     @ViewBuilder
    ///     private func destinationView(for route: BookingRoutes) -> some View {
    ///         switch route {
    ///         case .touristPlace:
    ///             BookingTouristPlace()
    ///
    ///         case .availableDate:
    ///             BookingAvailableDate()
    ///
    ///         case .infoDetails:
    ///             BookingInfoDetails()
    ///         }
    ///     }
    /// }
    /// ```
    ///
    /// 3. **Consume in Child View**:
    /// ```swift
    /// struct SelectPlaceView: View {
    ///     @Environment(AppRouter.FlowRouter<BookingRoutes>.self) var router
    ///
    ///     var body: some View {
    ///         Button("Next Step") {
    ///             router.next()
    ///         }
    ///     }
    /// }
    /// ```
    @Observable
    final class FlowRouter<Route: Hashable> {
        private let flow: [Route]

        var path = NavigationPath() {
            didSet { syncCurrentStep() }
        }

        private(set) var currentStep = 0

        /// Initializes the router with a specific sequence of steps.
        /// - Parameter flow: An array of routes defining the order of the flow.
        init(flow: [Route]) {
            self.flow = flow
        }

        private var canGoNext: Bool { currentStep < flow.count - 1 }
        private var canGoBack: Bool { currentStep > 0 }

        /// Advances to the next step in the flow if available.
        func next() {
            guard canGoNext else { return }
            path.append(flow[currentStep + 1])
        }

        /// Goes back to the previous step in the flow.
        func previous() {
            guard canGoBack else { return }
            path.removeLast()
        }

        /// Resets the flow to the beginning.
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
