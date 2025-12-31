//
//  TapBar.swift
//  Traveling
//
//  Created by Ivan Pereira on 29-12-25.
//

import SwiftUI
import TravelinDesignSystem

struct TapBar: View {

    @Environment(\.appRouter) private var appRouter

    // Define los items del TabBar
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

// Modelo para los items del TabBar
struct TabItem: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let route: AppRoutes
}

// Componente reutilizable para cada botón
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
