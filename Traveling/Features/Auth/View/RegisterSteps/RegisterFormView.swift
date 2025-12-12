//
//  RegisterFormView.swift
//  Traveling
//
//  Created by Ignacio Alvarado on 09-12-25.
//

import SwiftUI
import TravelinDesignSystem

struct RegisterFormView<VM: RegisterViewModelProtocol>: View {
    
    // MARK: - Dependencies
    // Inyectamos el Router (para avanzar con .next())
    @Environment(AppRouter.FlowRouter<RegisterRoutes>.self) private var registerRouter
    
    // Inyectamos dismiss para poder SALIR de esta vista hacia atrás
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - State
    @State private var registerViewModel: VM
    @State private var selectedPhoneCode = "+569"
    
    // MARK: - Init
    init(registerViewModel: VM) {
        _registerViewModel = State(initialValue: registerViewModel)
    }
    
    // MARK: - Body
    var body: some View {
        // ScrollView es vital para que el teclado no tape el botón final
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                header
                form
                footer
            }
            .padding(.horizontal, 24)
            .padding(.top, 10)
        }
        .navigationBarHidden(true) // Ocultamos el nav nativo para usar el nuestro custom
    }
    
    // MARK: - Components
    
    private var header: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            // 1. Botón de Retroceso Custom
            Button(action: {
                // Usamos dismiss() porque estamos en la raíz del flujo de registro
                dismiss()
            }) {
                Image(systemName: "arrow.left")
                    .font(.system(size: 20, weight: .bold)) // Un poco más grueso
                    .foregroundColor(.black)
                    .padding(10)
                    .background(
                        Circle()
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1) // Borde sutil
                    )
            }
            // Alineamos el botón a la izquierda
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // 2. Textos con Design Tokens
            VStack(alignment: .leading, spacing: 8) {
                Text("Create Account")
                    // Ajusta esto según tus tokens reales, ej: .heading1
                    .font(TravelinDesignSystem.DesignTokens.Typography.heading1)
                    .foregroundColor(.black)
                
                Text("Get the best out of Traveling by creating an account")
                    .font(TravelinDesignSystem.DesignTokens.Typography.body)
                    .foregroundColor(TravelinDesignSystem.DesignTokens.Colors.secondaryText)
            }
        }
    }
    
    private var form: some View {
        VStack(spacing: 16) {
            
            // Nombre
            DSTextField(
                placeHolder: "register.firstNamePlaceHolder".localized,
                type: .givenName,
                label: "register.firstNameTextFieldLabel".localized,
                style: .outlined,
                text: $registerViewModel.firstName
            )
            
            // Apellido
            DSTextField(
                placeHolder: "register.lastNamePlaceHolder".localized,
                type: .familyName,
                label: "register.lastNameTextFieldLabel".localized,
                style: .outlined,
                text: $registerViewModel.lastName
            )
            
            // Teléfono (Con ZIndex para el Dropdown)
            HStack(spacing: 12) {
                DSDropDown(items: ["+569", "+1", "+54"], selectedItem: $selectedPhoneCode)
                    .frame(width: 100)
                
                DSTextField(
                    placeHolder: "register.phonePlaceHolder".localized,
                    type: .phoneNumber,
                    style: .outlined,
                    text: $registerViewModel.phone
                )
            }
            .zIndex(1)
            
            // Email
            DSTextField(
                placeHolder: "register.emailPlaceHolder".localized,
                type: .email,
                label: "register.emailTextFieldLabel".localized,
                style: .outlined,
                text: $registerViewModel.email
            )
            
            // Password
            DSTextField(
                placeHolder: "register.passwordPlaceHolder".localized,
                type: .passwordLetters,
                label: "register.passwordTextFieldLabel".localized,
                style: .outlined,
                text: $registerViewModel.password
            )
            
            Spacer().frame(height: 20)
            
            // Botón de Acción
            DSButton(title: "register.createAccountButtonTitle".localized, variant: .primary) {
                print("Create Account Tapped")
            }
        }
    }
    
    private var footer: some View {
        HStack {
            Text("Already have an account?")
                .font(TravelinDesignSystem.DesignTokens.Typography.body)
                .foregroundColor(TravelinDesignSystem.DesignTokens.Colors.secondaryText)
            
            Button(action: {
                dismiss() // Volver al Login
            }) {
                Text("Log In")
                    .font(TravelinDesignSystem.DesignTokens.Typography.bodyBold)
                    .foregroundColor(TravelinDesignSystem.DesignTokens.Colors.linkText)
            }
        }
        .padding(.bottom, 20)
    }
}

// MARK: - Preview
#Preview {
    // Simulamos el entorno del Router para que no crashee el preview
    RegisterFormView(registerViewModel: RegisterViewModel())
        .environment(AppRouter.FlowRouter<RegisterRoutes>(flow: [.form, .success]))
}
