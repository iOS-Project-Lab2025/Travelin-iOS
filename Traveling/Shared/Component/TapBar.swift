//
//  TapBar.swift
//  Traveling
//
//  Created by Ivan Pereira on 29-12-25.
//

import SwiftUI
import TravelinDesignSystem

/// A custom tab bar component that allows navigation between main sections of the app.
///
/// `TapBar` displays a horizontal list of buttons, each representing a navigation destination.
/// It uses `appRouter` from the environment to manage navigation state and highlighting.
///
/// ## Usage Example
/// The `TapBar` is typically used in the root view (e.g., `ContentView`) within a `ZStack` or `VStack` to overlay or position it at the bottom of the screen.
///
/// ```swift
/// struct ContentView: View {
///     @Environment(\.appRouter) private var router
///
///     var body: some View {
///         ZStack {
///             // Main Content
///             switch router.path {
///             case .home:
///                 HomeView()
///             case .favorites:
///                 FavoritesView()
///             case .profile:
///                 ProfileView()
///             default:
///                 EmptyView()
///             }
///
///             // Show TapBar only for specific routes
///             if shouldShowTabBar {
///                 VStack {
///                     Spacer()
///                     TapBar()
///                 }
///             }
///         }
///     }
///
///     private var shouldShowTabBar: Bool {
///         // Logic to determine visibility
///         return true
///     }
/// }
/// ```
struct TapBar: View {

    @Environment(\.appRouter) private var appRouter

    // Defines the TabBar items
    private let tabItems: [TabItem] = [
        TabItem(icon: "house.fill", title: "Home", route: .home),
        TabItem(icon: "heart.fill", title: "Trips", route: .favorites),
        TabItem(icon: "person.crop.circle.fill", title: "Profile", route: .profile)
    ]

    // Helper to determine if a route is active
    private func isRouteActive(_ route: AppRoutes) -> Bool {
        if case route = appRouter.path {
            return true
        }
        return false
    }

    var body: some View {
        HStack(spacing: 0) {
            ForEach(tabItems) { item in
                Spacer()

                TabBarButton(
                    icon: item.icon,
                    title: item.title,
                    isActive: isRouteActive(item.route),
                    action: {
                        if !isRouteActive(item.route) {
                            appRouter.goTo(item.route)
                        }
                    }
                )
            }

            Spacer()
        }
        .padding(.vertical, 12)
        .background(Color.white)
        .shadow(
            color: Color(red: 175/255, green: 175/255, blue: 175/255).opacity(0.10),
            radius: 8,
            x: 0,
            y: -8
        )
    }
}

// Model for the TabBar items
/// Represents a single item in the `TapBar`.
struct TabItem: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let route: AppRoutes
}

// Reusable component for each button
/// A single button within the `TapBar`.
struct TabBarButton: View {
    let icon: String
    let title: String
    let isActive: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                Text(title)
                    .font(.system(size: 12))
            }
        }
        .foregroundColor(isActive ? .blue : .gray)
    }
}

#Preview {
    TapBar()
}
