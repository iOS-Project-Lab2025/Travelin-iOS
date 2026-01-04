//
//  SearchView.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 30-12-25.
//

import SwiftUI
import TravelinDesignSystem

struct SearchView: View {
    @FocusState private var focused: Bool
    @Binding var viewModel: HomeViewModel
    @Binding var router: AppRouter.PathRouter<HomeRoutes>
    @State private var showAllPOI: Bool = false
    let size: CGSize

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {

                // Contenido
                if viewModel.searchDetail.searchText.isEmpty {
                    VStack(alignment: .leading)  {
                        Button {
                            Task {
                                await viewModel.fetchChileanPOI()
                                focused = false
                            }
                        } label: {
                            VStack(spacing:0) {
                                HStack(alignment: .center) {
                                    Image(systemName: "drop.circle")
                                        .font(.system(size: 32))
                                        .symbolRenderingMode(.palette)   // Permite usar varios colores
                                        .symbolRenderingMode(.hierarchical)
                                        .foregroundStyle(Color.gray)
                                    VStack(alignment: .leading) {
                                        Text("Search place nearby")
                                            .foregroundStyle(.black)
                                            .font(.system(size: 20, weight: .bold))
                                        Text("Current location - Chile")
                                            .foregroundStyle(.black)
                                            .font(.system(size: 14, weight: .light))
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                Rectangle()
                                    .fill(Color.gray.opacity(0.8))
                                    .frame(height: 1 / UIScreen.main.scale)
                                    .padding(.all)
                            }
                            // Un color por capa
                        }
                        .padding()
                        ReusablePackageSearchView(packages: $viewModel.allNearbyPackages, router: $router, totalPackage: ($viewModel.allNearbyPackages.count), size: size)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .onDisappear {
                        viewModel.allNearbyPackages = []
                    }
                } else {
                    
                    VStack(alignment: .leading) {
                        Text("Place name \"\(viewModel.searchDetail.searchText)\" ")
                            .foregroundStyle(.primary)
                            .font(.system(size: 20, weight: .bold))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                            .padding(.top)
                        
                        ReusablePackageSearchView(packages: $viewModel.allPoiPackages, router: $router, totalPackage: (showAllPOI ? $viewModel.allPoiPackages.count : 3), size: size)

                        if $viewModel.allPoiPackages.count > 3 {
                            Button {
                                showAllPOI.toggle()
                            } label: {
                                Text("\(showAllPOI ? "Hide": "Show") + \(showAllPOI ? $viewModel.allPoiPackages.count : $viewModel.allPoiPackages.count - 3)")
                                    .foregroundStyle(.black)
                                    .font(.system(size: 14, weight: .bold))
                                    .frame(width: size.width * 0.5)
                                    .padding(.vertical, 12)
                            }
                            .buttonStyle(.plain)
                            .padding(.horizontal, 16)
                            .overlay {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray.opacity(0.35), lineWidth: 2)
                                    .padding(.horizontal, 16)
                            }
                            .padding(.top, 12)
                            .padding(.bottom, 16)
                            
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .onAppear() {
                focused = true
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)   // ✅ el teclado no empuja
        .navigationBarHidden(true)                    // ✅ apaga navbar sistema
        .onTapGesture {
                    focused = false          // ✅ cierra teclado
                }
        

        // ✅ Header fijo que respeta safe area
        .safeAreaInset(edge: .top, spacing: 0) {
            VStack(spacing: 0) {
                HStack(spacing: 12) {
                    Button {
                        focused = false
                        router.previous()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundStyle(.black)
                            .frame(width: 44, height: 44)
                    }
                    .buttonStyle(.plain)
                    

                    DSTextField(
                        symbolPosition: viewModel.searchDetail.searchText.isEmpty ? .left : .right,
                        placeHolder: viewModel.searchDetail.searchText.isEmpty ? "Where do you plan to go?" : "",
                        type: .search,
                        style: .outlined,
                        text: $viewModel.searchDetail.searchText
                    )
                    .focused($focused)

                    if !viewModel.searchDetail.searchText.isEmpty {
                        Image(systemName: "square.grid.3x2.fill")
                            .font(.system(size: 16))
                            .rotationEffect(.degrees(90))
                            .foregroundStyle(.primary)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(Color.white)

                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 1 / UIScreen.main.scale)
            }
        }
    }
}


#Preview {
    NavigationStack {
        SearchView( viewModel: .constant(HomeViewModel()), router: .constant(AppRouter.PathRouter<HomeRoutes>())
                   , size: CGSize(width: UIScreen.main.bounds.width , height: UIScreen.main.bounds.width * 0.38))
    }
}





