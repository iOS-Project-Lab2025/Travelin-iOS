//
//  TopHomeView.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 10-12-25.
//

import TravelinDesignSystem
import SwiftUI

struct TopHomeView: View {
    /// Router used to navigate from Home header to Search screen.
    /// Provided by HomeView via .environment(homeRouter).
    /// Routes are defined by HomeRoutes (e.g., .poiSearch).
    @Environment(AppRouter.PathRouter<HomeRoutes>.self) private var router

    /// Shared search state owned by HomeViewModel.
    /// This view writes searchText and searchType (filters).
    /// Bound from HomeView: $viewModel.searchDetail.
    @Binding var searchDetail: SearchDetail

    /// Geometry-driven sizing for responsive layout.
    /// Used to size the hero image and keep proportions stable.
    /// Passed from GeometryReader (geo.size).
    let screenSize: CGSize
    
    var body: some View {
        /// Hero header: background image + stacked content on top.
        /// Content includes title, subtitle, a "fake" search launcher, and filters.
        /// Padding keeps text readable against the image edges.
        ZStack {
            self.backgroundImageView
            VStack(alignment: .leading) {
                self.titleView
                self.subTitleView
                self.falseSearchFieldView
                self.filtersView
            }
            .padding()
        }
    }

    private var backgroundImageView: some View {
        /// Hero background image for Home header.
        /// Uses scaledToFill + clipped to cover the top area.
        /// Adds a dark overlay for better text contrast.
        VStack {
            Image("principalHome")
                .resizable()
                .scaledToFill()
                .frame(width: screenSize.width, height: screenSize.height * 0.45)
                .overlay(TravelinDesignSystem.DesignTokens.Colors.darkButtonBackgroundPressed.opacity(0.2))
                .clipped()
                .minimumScaleFactor(0.7)
        }
    }

    private var titleView: some View {
        /// Main headline displayed over the hero image.
        /// Styled with design system typography and white color.
        /// Top padding separates it from the safe area edge.
        Text("Explore the world today")
            .foregroundStyle(.white)
            .font(TravelinDesignSystem.DesignTokens.Typography.heading1)
            .padding(.top, TravelinDesignSystem.DesignTokens.Spacing.mediumLarge)
    }

    private var subTitleView: some View {
        /// Subtitle with mixed emphasis (bold "Discover").
        /// Rendered as a concatenated Text for partial styling.
        /// Uses design system title typography.
        (
            Text("Discover ")
                .bold()
            + Text("- take your travel to next level")
        )
        .font(TravelinDesignSystem.DesignTokens.Typography.title2)
        .foregroundStyle(.white)
    }

    private var falseSearchFieldView: some View {
        /// Looks like a search field but acts as a navigation trigger.
        /// Overlay intercepts taps and routes to the Search screen.
        /// The actual editable search field lives in SearchView.
        DSTextField(
            symbolPosition: .right,
            placeHolder: "Search Destination",
            type: .search,
            style: .default,
            text: self.$searchDetail.searchText)
        .overlay {
            Rectangle()
                .fill(.clear)
                .contentShape(Rectangle())
                .onTapGesture {
                    self.router.goTo(
                        .poiSearch
                    )
                }
        }
    }

    private var filtersView: some View {
        /// Two toggle buttons that update searchDetail.searchType.
        /// Selected state changes DSButton variant (dark vs ghost).
        /// Tapping an active filter resets it back to .all.
        HStack {
            DSButton(
                title: "Hotel",
                icon: Image(systemName: "bed.double.fill"),
                iconPosition: .leading,
                variant: self.searchDetail.searchType == .hotel ? .dark : .ghost,
                size: .large,
                fullWidth: true,
                fixedWidth: 100
            ) {
                if self.searchDetail.searchType == .hotel {
                    self.searchDetail.searchType = .all
                } else {
                    self.searchDetail.searchType = .hotel
                }
            }
            Spacer()
            DSButton(
                title: "Oversea",
                icon: Image(systemName: "airplane"),
                iconPosition: .leading,
                variant: self.searchDetail.searchType == .oversea ? .dark : .ghost,
                size: .large,
                fullWidth: true,
                fixedWidth: 100
            ) {
                if self.searchDetail.searchType == .oversea {
                    self.searchDetail.searchType = .all
                } else {
                    self.searchDetail.searchType = .oversea
                }
            }
        }
        .padding(.top)
    }
}

#Preview {
    /// Preview injects a constant SearchDetail and uses screen bounds.
    /// Useful to validate layout over the hero image.
    /// Navigation won't work in preview without router environment.
    TopHomeView(searchDetail: .constant(SearchDetail()), screenSize: UIScreen.main.bounds.size)
}

