//
//  RegisterFormView.swift
//  Traveling
//
//  Created by Ivan Pereira on 23-11-25.
//

import SwiftUI

struct RegisterFormView: View {

    @Environment(AppRouter.FlowRouter<RegisterRoutes>.self) private var registerRouter

    var body: some View {
        VStack {
            Text("Register Form")
            Button {
                registerRouter.next()
            } label: {
                Text("Next")
            }

        }
    }
}

#Preview {
    RegisterFormView()
}
