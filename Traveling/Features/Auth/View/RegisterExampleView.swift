// RegisterExampleView.swift
// Traveling
// ONLY FOR EXAMPLE, DELETE IT AFTER

import SwiftUI

struct RegisterExampleView: View {
    // Usamos el ViewModel actualizado
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
                // CORRECCIÓN 1: La función ahora se llama createAccount()
                // y ya maneja el Task internamente, así que no necesitas 'await' ni 'Task' aquí
                viewModel.createAccount()
            }) {
                // CORRECCIÓN 2: La variable ahora se llama 'state'
                if viewModel.state == .loading {
                    ProgressView()
                } else {
                    Text("Registrarse")
                }
            }
            
            // CORRECCIÓN 3: Actualizar referencias a 'state'
            if case .success = viewModel.state {
                Text("✅ Registrado correctamente").foregroundColor(.green)
            }
            
            if case .failure(let error) = viewModel.state {
                Text("❌ Error: \(error.localizedDescription)").foregroundColor(.red)
            }
        }
        .navigationTitle("Registro Ejemplo")
    }
}

#Preview {
    RegisterExampleView()
}
