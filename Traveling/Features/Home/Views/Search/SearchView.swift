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
                
                if viewModel.searchDetail.searchText.isEmpty {
                    VStack(alignment: .leading)  {
                        buttonNearbyView
                        ReusableSearchPackageCollectionView(packages: $viewModel.allNearbyPackages, router: $router, totalPackage: ($viewModel.allNearbyPackages.count), size: size)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .onDisappear {
                        viewModel.allNearbyPackages = []
                    }
                } else {
                    
                    VStack(alignment: .leading) {
                        placeNameView
                        
                        ReusableSearchPackageCollectionView(packages: $viewModel.allPoiPackages, router: $router, totalPackage: (showAllPOI ? $viewModel.allPoiPackages.count : 3), size: size)
                        
                        if $viewModel.allPoiPackages.count > 3 {
                            buttonShowTotalPOIView
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .onAppear() {
                focused = true
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .navigationBarHidden(true)
        .onTapGesture {
            focused = false
        }
        .safeAreaInset(edge: .top, spacing: 0) {
            headerSearchView
        }
    }
    private var buttonNearbyView: some View {
        Button {
            Task {
                await viewModel.fetchChileanPOI()
                focused = false
            }
        } label: {
            VStack(spacing: 0) {
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
                lineView
                    .padding(.all)
            }
            // Un color por capa
        }
        .padding()
    }
    private var lineView: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.8))
            .frame(height: 1 / UIScreen.main.scale)
    }
    private var placeNameView: some View {
        Text("Place name \"\(viewModel.searchDetail.searchText)\" ")
            .foregroundStyle(.primary)
            .font(.system(size: 20, weight: .bold))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            .padding(.top)
    }
    private var buttonShowTotalPOIView: some View {
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
    private var backButtonView: some View {
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
    }
    private var squareGridView: some View {
        Image(systemName: "square.grid.3x2.fill")
            .font(.system(size: 16))
            .rotationEffect(.degrees(90))
            .foregroundStyle(.primary)
    }
    private var headerSearchView: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                backButtonView
                DSTextField(
                    symbolPosition: viewModel.searchDetail.searchText.isEmpty ? .left : .right,
                    placeHolder: viewModel.searchDetail.searchText.isEmpty ? "Where do you plan to go?" : "",
                    type: .search,
                    style: .outlined,
                    text: $viewModel.searchDetail.searchText
                )
                .focused($focused)
                if !viewModel.searchDetail.searchText.isEmpty {
                    squareGridView
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(Color.white)
            lineView
        }
    }
}

#Preview {
    NavigationStack {
        SearchView( viewModel: .constant(HomeViewModel()), router: .constant(AppRouter.PathRouter<HomeRoutes>())
                    , size: CGSize(width: UIScreen.main.bounds.width , height: UIScreen.main.bounds.width * 0.38))
    }
}





