//
//  OnboardingView.swift
//  Traveling
//
//  Created by NVSH on 19-11-25.
//

import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false

    @State private var currentStep = 0

    var body: some View {
        ZStack {
            TabView(selection: $currentStep){
                ForEach(0..<onboardingSteps.count, id: \.self) { index in
                    Image(onboardingSteps[index].image)
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .animation(.easeInOut, value: currentStep)
            .ignoresSafeArea()
            
            // --- CAPA 2: TARJETA FLOTANTE (TEXTOS + BOTÓN) ---
            VStack {
                Spacer()
                
                HStack{
                    Image("AppLogoGray")
                        .frame(width: 100, height: 100)
                    Spacer()
                }
                .padding(10)
                
                // ESTE VStack ES LA "TARJETA" BLANCA
                VStack(spacing: 20) {
                    
                    VStack(){
                        
                    }
                    // 1. Título
                    Text(onboardingSteps[currentStep].title)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    
                    // 2. Descripción
                    Text(onboardingSteps[currentStep].description)
                        .font(.body)
                        .foregroundColor(.gray)
                    
                    // 4. Botón
                    Button(action: handleNextButton) {
                        Text(currentStep == onboardingSteps.count - 1 ? "Let's Go" : "Next")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 55)
                            .background(currentStep == onboardingSteps.count - 1 ? Color.green : Color.blue)
                            .cornerRadius(15)
                    }
                    
                
                }
                .frame(height: 300)
                .padding(20) // Relleno INTERNO de la tarjeta (espacio entre borde blanco y textos)
                .background( // AQUI aplicamos el fondo blanco a todo el grupo
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color.white)
                        .shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: 10)
                )
                .padding(.horizontal, 12)
                .padding(.bottom, 20)
                
                // 3. Indicadores (Puntitos) - Ahora dentro de la tarjeta
                HStack() {
                    ForEach(0..<onboardingSteps.count, id: \.self) { index in
                        Rectangle()
                            .frame(width: 18, height: 6)
                            .foregroundColor(currentStep == index ? .white : .gray.opacity(0.8))
                            .cornerRadius(20)

                            .animation(.spring(), value: currentStep)
                            
                    }
                }
                
            }
        }
    }
    
    func handleNextButton() {
        if currentStep < onboardingSteps.count - 1 {
            withAnimation {
                currentStep += 1
            }
        } else {
            withAnimation {
                hasCompletedOnboarding = true
            }
        }
    }
}

#Preview {
    OnboardingView()
}
