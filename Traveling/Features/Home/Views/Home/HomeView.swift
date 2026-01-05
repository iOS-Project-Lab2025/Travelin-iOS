//
//  MainView.swift
//  Traveling
//
//  Created by Ivan Pereira on 18-11-25.
//

import SwiftUI

struct HomeView: View {
    @State private var homeRouter = AppRouter.PathRouter<HomeRoutes>()
    @State private var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationStack(path: self.$homeRouter.path) {
            GeometryReader { geo in
                VStack(spacing: 0) {
                    TopHomeView(
                        searchDetail: self.$viewModel.searchDetail,
                        screenSize: geo.size
                    )
                    .ignoresSafeArea(edges: .top)
                    .onAppear {
                        self.viewModel.searchDetail.searchText = ""
                    }
                    ScrollView(.vertical) {
                        HomePackageCollectionView(
                            viewModel: self.$viewModel,
                            screenSize: geo.size
                        )
                        HomeCountriesCollectionView(
                            countries: self.viewModel.countries,
                            screenSize: geo.size
                        )
                    }
                    .padding(.top)
                }
                .onAppear {  // ✅ Mejor lugar para async
                    self.viewModel.searchDetail.searchType = .all
                }
                .ignoresSafeArea(edges: .top)
                .navigationDestination(for: HomeRoutes.self) { route in
                    switch route {
                    case .poiSearch:
                        SearchView(viewModel: self.$viewModel, screenSize: geo.size)
                    case .poiDetail(let id):
                        detailPackageDestination(packages: $viewModel.allPoiPackages, id: id)
                    }
                }
            }
        }
        .environment(self.homeRouter)
    }
    @ViewBuilder
    private func detailPackageDestination(
        packages: Binding<[Package]>,
        id: String
    ) -> some View {
        
        if let index = packages.wrappedValue.firstIndex(where: { $0.id == id }) {
            DetailPackageView(package: packages[index])   // ✅ Binding<Package>
        } else {
            Text("Package not found")
        }
    }
    
}


