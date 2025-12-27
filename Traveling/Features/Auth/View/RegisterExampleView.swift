// RegisterExampleView.swift
// Traveling
// ONLY FOR EXAMPLE, DELETE IT AFTER


import SwiftUI

struct RegisterExampleView: View {
    @StateObject private var viewModel = RegisterViewModel()

    var body: some View {
        Form {
            Section(header: Text("Datos de registro")) {
                TextField("Email", text: $viewModel.email)
                    .keyboardType(.emailAddress)
                SecureField("Contraseña", text: $viewModel.password)
                TextField("Nombre (opcional)", text: $viewModel.firstName)
                TextField("Apellido (opcional)", text: $viewModel.lastName)
                TextField("Teléfono (opcional)", text: $viewModel.phone)
            }
            Button(action: {
                Task { await viewModel.register() }
            }) {
                if viewModel.registerState == .loading {
                    ProgressView()
                } else {
                    Text("Registrarse")
                }
            }
            if case .success = viewModel.registerState {
                Text("✅ Registrado correctamente").foregroundColor(.green)
            }
            if case .failure(let error) = viewModel.registerState {
                Text("❌ Error: \(error.localizedDescription)").foregroundColor(.red)
            }
        }
        .navigationTitle("Registro Ejemplo")
    }
}

#Preview {
    RegisterExampleView()
}
