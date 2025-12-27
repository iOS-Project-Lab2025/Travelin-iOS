//
//  RegisterView.swift
//  Traveling
//
//  Created by Ivan Pereira on 21-11-25.
//


import SwiftUI

struct RegisterView: View {

    @State private var registerRouter = AppRouter.FlowRouter<RegisterRoutes>(flow: [.form, .success])
    @State private var registerViewModel: RegisterViewModel

    init(registerViewModel: RegisterViewModel) {
        _registerViewModel = State(initialValue: registerViewModel)
    }

    var body: some View {
        NavigationStack(path: $registerRouter.path) {
            // ONLY FOR EXAMPLE, CHANGE IT AFTER
            RegisterExampleView()
                .navigationDestination(for: RegisterRoutes.self) { route in
                    destinationView(for: route)
                }
        }
        .environment(registerRouter)
    }
    @ViewBuilder
    private func destinationView(for route: RegisterRoutes) -> some View {
        switch route {
        case .form:
            RegisterExampleView()
        case .success:
            RegisterSuccessView()
        }
    }
}
