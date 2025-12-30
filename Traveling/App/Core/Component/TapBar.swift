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

    var body: some View {
        Spacer()
        HStack(spacing: 0) {
            Spacer()

            TabBarButton(
                icon: "house.fill",
                title: "Home",
                isActive: true,
                action: { appRouter.goTo(.home) }
            )

            Spacer()

            TabBarButton(
                icon: "heart.fill",
                title: "Trips",
                isActive: false,
                action: { appRouter.goTo(.favorites) }
            )

            Spacer()

            TabBarButton(
                icon: "person.crop.circle.fill",
                title: "Profile",
                isActive: false,
                action: { appRouter.goTo(.profile) }
            )

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
