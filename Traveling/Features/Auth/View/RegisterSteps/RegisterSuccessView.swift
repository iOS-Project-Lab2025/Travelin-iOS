//
//  RegisterSuccessView.swift
//  Traveling
//
//  Created by Ivan Pereira on 23-11-25.
//

import SwiftUI

struct RegisterSuccessView: View {
    @Environment(\.appRouter) private var appRouter
    var body: some View {
        VStack {
            Text("Register Success")
            Button {
                appRouter.goTo(.home)
            } label: {
                Text("Go Home")
            }

        }
    }
}

#Preview {
    RegisterSuccessView()
}
