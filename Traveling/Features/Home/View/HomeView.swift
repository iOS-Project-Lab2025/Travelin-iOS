//
//  MainView.swift
//  Traveling
//
//  Created by Ivan Pereira on 18-11-25.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.appRouter) private var router

    private let options: [(title: String, route: AppRoutes)] = [
        ("Go to Onboarding", .onBoarding),
        ("Go to Login", .authentication(.login)),
        ("Go to Register", .authentication(.register)),
        ("Go to Profile", .profile),
        ("Go to Booking", .booking)
    ]

    var body: some View {
        VStack {
            Text("Home")

            List(options, id: \.title) { option in
                Button(option.title) {
                    router.goTo(option.route)
                }
            }
        }
        
        TapBar()
    }
}
