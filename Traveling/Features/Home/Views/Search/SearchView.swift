//
//  SearchView.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 30-12-25.
//

import SwiftUI
import TravelinDesignSystem

struct SearchView: View {
    /// Controls keyboard focus for the search text field.
    /// Set true on appear to auto-focus; set false to dismiss keyboard.
    /// Used with .focused(...) on the DSTextField.
    @FocusState private var focused: Bool

    /// Router used to navigate back (reset) and to detail routes via child lists.
    /// Provided by HomeView through .environment(homeRouter).
    /// Routes are defined by HomeRoutes.
    @Environment(AppRouter.PathRouter<HomeRoutes>.self) private var router

    /// Shared HomeViewModel binding (single source of truth across Home/Search/Detail).
    /// Provides searchDetail + lists (nearby + filtered) and fetch/filter methods.
    /// Mutations here propagate back to HomeView.
    @Binding var viewModel: HomeViewModel

    /// Controls "Show/Hide" behavior for filtered results (3 items vs all items).
    /// Only relevant when searchText is not empty.
    /// Toggled by buttonShowTotalPOIView.
    @State private var showAllPOI: Bool = false

    /// Used for responsive sizing (list item sizes, button widths, dividers).
    /// Passed from GeometryReader in HomeView.
    /// Keeps layout consistent across devices.
    let screenSize: CGSize
    
    var body: some View {
        /// Main scroll container for the results area.
        /// Content switches between Nearby mode and Filtered mode based on searchText.
        /// Header is injected via safeAreaInset (custom navigation bar).
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                if self.viewModel.searchDetail.searchText.isEmpty {
                    /// Nearby mode: shows "Search place nearby" button + nearby results list.
                    /// Results come from viewModel.allNearbyPackages (filled by fetchChileanPOI()).
                    /// This block clears nearby results on disappear.
                    VStack(alignment: .leading)  {
                        self.buttonNearbyView
                        ReusableSearchPackageCollectionView(
                            packages: self.viewModel.allNearbyPackages,
                            totalPackage: (self.viewModel.allNearbyPackages.count),
                            screenSize: self.screenSize
                        )
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .onDisappear {
                        /// Clears nearby results when leaving this branch/screen.
                        /// This also runs when switching to the non-empty-text branch.
                        /// Keeps state lightweight but requires refetch on return.
                        self.viewModel.allNearbyPackages = []
                    }
                } else {
                    /// Filtered mode: shows a title and filtered list (3 or all).
                    /// Filtered list is computed by viewModel.updateSearch() (onChange below).
                    /// "Show/Hide" button appears only when there are more than 3 results.
                    VStack(alignment: .leading) {
                        self.placeNameView
                        ReusableSearchPackageCollectionView(
                            packages: self.viewModel.allNearbyFilterPackages,
                            totalPackage: (self.showAllPOI ? self.viewModel.allNearbyFilterPackages.count : 3),
                            screenSize: self.screenSize
                        )
                        if self.viewModel.allNearbyFilterPackages.count > 3 {
                            self.buttonShowTotalPOIView
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .onAppear {
                /// Auto-focus the search field when the screen appears.
                /// Improves UX: keyboard is ready for typing immediately.
                /// User can dismiss by tapping outside.
                self.focused = true
            }
        }
        /// Prevents the keyboard from pushing content in an undesirable way.
        /// Uses a custom header instead of the default navigation bar.
        /// Tapping on the content dismisses keyboard focus.
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .navigationBarHidden(true)
        .onTapGesture {
            self.focused = false
        }
        /// Custom header pinned to the top safe area.
        /// Contains back button + DSTextField + optional grid icon.
        /// Replaces the standard navigation bar.
        .safeAreaInset(edge: .top, spacing: 0) {
            self.headerSearchView
        }
        /// Live search: updates filtered list every time the search text changes.
        /// Delegates filtering logic to HomeViewModel.updateSearch().
        /// Results end up in viewModel.allNearbyFilterPackages.
        .onChange(of: viewModel.searchDetail.searchText) { _, _ in
            viewModel.updateSearch()
        }
    }

    private var buttonNearbyView: some View {
        /// Triggers nearby POI fetch (Chile bounding box) using async Task.
        /// After fetching, it dismisses the keyboard.
        /// Results are displayed via allNearbyPackages list.
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
        }
        .padding()
    }

    private var lineView: some View {
        /// Thin divider line using device scale for crisp rendering.
        /// Reused in multiple places (nearby card and header bottom).
        /// Keeps visual separation consistent across sections.
        Rectangle()
            .fill(Color.gray.opacity(0.8))
            .frame(height: 1 / UIScreen.main.scale)
    }

    private var placeNameView: some View {
        /// Header text for filtered mode.
        /// Shows the current query to confirm what is being searched.
        /// Left-aligned with padding consistent with the design system.
        Text("Place name \"\(viewModel.searchDetail.searchText)\"")
            .foregroundStyle(.primary)
            .font(TravelinDesignSystem.DesignTokens.Typography.title1.bold())
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            .padding(.top)
    }

    private var buttonShowTotalPOIView: some View {
        /// Toggles between showing 3 items and showing all filtered items.
        /// Label displays "Show/Hide + N" (computed from counts).
        /// Note: current count logic references allPoiPackages (project choice/placeholder).
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
        /// Back action: dismiss keyboard and reset the router path.
        /// router.reset() returns to Home within the same NavigationStack.
        /// Uses plain style to avoid default button styling.
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
        /// Optional icon shown when the search text is not empty.
        /// Rotated to match the intended visual design.
        /// Currently decorative (no action attached).
        Image(systemName: "square.grid.3x2.fill")
            .font(TravelinDesignSystem.DesignTokens.Typography.title2)
            .rotationEffect(.degrees(90))
            .foregroundStyle(.primary)
    }

    private var headerSearchView: some View {
        /// Custom top bar: back button + outlined DSTextField.
        /// Placeholder and search icon position adapt to whether text is empty.
        /// Adds a divider line at the bottom for separation.
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
    /// Preview wraps SearchView in a NavigationStack for layout parity.
    /// Uses a constant HomeViewModel instance for bindings.
    /// Router environment isn't injected here, so navigation actions won't run.
    NavigationStack {
        SearchView(
            viewModel: .constant(HomeViewModel()),
            screenSize: CGSize(width: UIScreen.main.bounds.width , height: UIScreen.main.bounds.width * 0.38)
        )
    }
}

