//
//  HomePackageCollectionView.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 10-12-25.
//

import SwiftUI
import TravelinDesignSystem

struct HomePackageCollectionView: View {
    @Environment(AppRouter.PathRouter<HomeRoutes>.self) private var router
    @Binding var viewModel: HomeViewModel
    let screenSize: CGSize
    
    var body: some View {
        VStack(spacing: 0) {
            self.titleView
            ScrollView(.horizontal) {
                LazyHStack(spacing: TravelinDesignSystem.DesignTokens.Spacing.buttonHorizontal) {
                    ForEach(self.$viewModel.allPoiPackages) { $package in
                        ReusablePackageView(
                            package: $package,
                            screenSize: self.screenSize,
                            onTap: {
                                self.router.goTo(.poiDetail(id: package.id))
                            }
                        )
                    }
                }
            }
        }
        .padding()
    }
    private var titleView: some View {
        Text("Popular package in asia")
            .font(TravelinDesignSystem.DesignTokens.Typography.title1.bold())
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    HomePackageCollectionView(viewModel: .constant(HomeViewModel()), screenSize: UIScreen.main.bounds.size
    )
}
