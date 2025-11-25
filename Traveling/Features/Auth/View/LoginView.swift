//
//  LoginView.swift
//  Traveling
//
//  Created by Ivan Pereira on 21-11-25.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.appRouter) var appRouter
    var body: some View {
        Text("Login View")

        Button {
            appRouter.goTo(.authentication(.register))
        } label: {
            Text("Create Account")
        }

        Button {
            appRouter.goTo(.home)
        } label: {
            Text("Go Home")
        }

    }
}
