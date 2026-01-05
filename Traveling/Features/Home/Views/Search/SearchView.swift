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
    @Environment(AppRouter.PathRouter<HomeRoutes>.self) private var router
    @Binding var viewModel: HomeViewModel
    @State private var showAllPOI: Bool = false
    let screenSize: CGSize
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                if self.viewModel.searchDetail.searchText.isEmpty {
                    VStack(alignment: .leading)  {
                        self.buttonNearbyView
                        ReusableSearchPackageCollectionView(packages: self.viewModel.allNearbyPackages, totalPackage: (self.viewModel.allNearbyPackages.count), screenSize: self.screenSize)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .onDisappear {
                        self.viewModel.allNearbyPackages = []
                    }
                } else {
                    VStack(alignment: .leading) {
                        self.placeNameView
                        ReusableSearchPackageCollectionView(packages: self.viewModel.allNearbyFilterPackages, totalPackage: (self.showAllPOI ? self.viewModel.allNearbyFilterPackages.count : 3), screenSize: self.screenSize)
                        if self.viewModel.allNearbyFilterPackages.count > 3 {
                            self.buttonShowTotalPOIView
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .onAppear {
                self.focused = true
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .navigationBarHidden(true)
        .onTapGesture {
            self.focused = false
        }
        .safeAreaInset(edge: .top, spacing: 0) {
            self.headerSearchView
        }
        .onChange(of: viewModel.searchDetail.searchText) { _, _ in
            viewModel.updateSearch()
        }
    }
    private var buttonNearbyView: some View {
        Button {
            Task {
                await self.viewModel.fetchChileanPOI()
                self.focused = false
            }
        } label: {
            VStack(spacing: 0) {
                HStack(alignment: .center) {
                    Image(systemName: "drop.circle")
                        .font(TravelinDesignSystem.DesignTokens.Typography.heading1)
                        
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(TravelinDesignSystem.DesignTokens.Colors.darkButtonBackgroundPressed)
                    VStack(alignment: .leading) {
                        Text("Search place nearby")
                            .foregroundStyle(.black)
                            .font(TravelinDesignSystem.DesignTokens.Typography.title1.bold())
                        Text("Current location - Chile")
                            .foregroundStyle(.black)
                            .font(TravelinDesignSystem.DesignTokens.Typography.bodyLargeRegular)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                self.lineView
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
        Text("Place name \"\(viewModel.searchDetail.searchText)\"")
            .foregroundStyle(.primary)
            .font(TravelinDesignSystem.DesignTokens.Typography.title1.bold())
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            .padding(.top)
    }
    private var buttonShowTotalPOIView: some View {
        Button {
            self.showAllPOI.toggle()
        } label: {
            Text("\(self.showAllPOI ? "Hide": "Show") + \(self.showAllPOI ? self.$viewModel.allPoiPackages.count : self.$viewModel.allPoiPackages.count - 3)")
                .foregroundStyle(TravelinDesignSystem.DesignTokens.Colors.primaryText)
                .font(TravelinDesignSystem.DesignTokens.Typography.bodyLargeMedium.bold())
                .frame(width: self.screenSize.width * 0.5)
                .padding(.vertical, TravelinDesignSystem.DesignTokens.Spacing.mediumSmall)
        }
        .buttonStyle(.plain)
        .padding(.horizontal, TravelinDesignSystem.DesignTokens.Spacing.medium)
        .overlay {
            RoundedRectangle(cornerRadius: TravelinDesignSystem.DesignTokens.Spacing.iconSpacingMenu)
                .stroke(Color.gray.opacity(0.35), lineWidth: 2)
                .padding(.horizontal, TravelinDesignSystem.DesignTokens.Spacing.medium)
        }
        .padding(.top, TravelinDesignSystem.DesignTokens.Spacing.mediumSmall)
        .padding(.bottom, TravelinDesignSystem.DesignTokens.Spacing.medium)
    }
    private var backButtonView: some View {
        Button {
            self.focused = false
            self.router.reset()
        } label: {
            Image(systemName: "chevron.left")
                .font(TravelinDesignSystem.DesignTokens.Typography.title2)
                .foregroundStyle(.black)
                .font(TravelinDesignSystem.DesignTokens.Typography.heading1)
        }
        .buttonStyle(.plain)
    }
    private var squareGridView: some View {
        Image(systemName: "square.grid.3x2.fill")
            .font(TravelinDesignSystem.DesignTokens.Typography.title2)
            .rotationEffect(.degrees(90))
            .foregroundStyle(.primary)
    }
    private var headerSearchView: some View {
        VStack(spacing: 0) {
            HStack(spacing: TravelinDesignSystem.DesignTokens.Spacing.mediumSmall) {
                self.backButtonView
                DSTextField(
                    symbolPosition: self.viewModel.searchDetail.searchText.isEmpty ? .left : .right,
                    placeHolder: self.viewModel.searchDetail.searchText.isEmpty ? "Where do you plan to go?" : "",
                    type: .search,
                    style: .outlined,
                    text: self.$viewModel.searchDetail.searchText
                )
                .focused(self.$focused)
                if !self.viewModel.searchDetail.searchText.isEmpty {
                    self.squareGridView
                }
            }
            .padding(.horizontal, TravelinDesignSystem.DesignTokens.Spacing.medium)
            .padding(.vertical, TravelinDesignSystem.DesignTokens.Spacing.iconSpacingMenu)
            .background(Color.white)
            self.lineView
        }
    }
}

#Preview {
    NavigationStack {
        SearchView( viewModel: .constant(HomeViewModel()), screenSize: CGSize(width: UIScreen.main.bounds.width , height: UIScreen.main.bounds.width * 0.38))
    }
}
