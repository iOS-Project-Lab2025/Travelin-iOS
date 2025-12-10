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
        NavigationStack(path: $homeRouter.path) {
            VStack(spacing: 0) {
                TopHomeView(searchDetail: $viewModel.searchDetail)
                    .edgesIgnoringSafeArea(.top)
                    .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: UIScreen.main.bounds.height * 0.35)
                    
                ScrollView(.vertical) {
                    HomePackageCollectionView(packages: $viewModel.packages)
                    HomeCountriesCollectionView(countries: $viewModel.countries)
                }
            }
        }
        .environment(homeRouter)
    }
    @ViewBuilder
    private func destinationView(for route: HomeRoutes) -> some View {
        switch route {
        case .globalSearch:
            HomeView()

        case .tourList:
            HomeView()
        }
    }
}
enum HomeRoutes: Hashable {
    case globalSearch
    case tourList
}
