//
//  RegisterFormView.swift
//  Traveling
//
//  Created by Ignacio Alvarado on 09-12-25.
//

import SwiftUI
import TravelinDesignSystem

struct RegisterFormView<VM: RegisterViewModelProtocol>: View {
    @Environment(AppRouter.FlowRouter<RegisterRoutes>.self) private var registerRouter
    @State private var registerViewModel: VM
    
    @State private var username: String = ""

    init(registerViewModel: VM) {
        self.registerViewModel = registerViewModel
        }
    
    var body: some View {
        VStack {
            form
        }
    }
    
    private var form: some View {

        VStack {
            TextField("Enter username", text: $username)
                .textFieldStyle(.roundedBorder)
                .padding()
        }
    }
}



#Preview {
    RegisterFormView(registerViewModel: RegisterViewModel())
}
