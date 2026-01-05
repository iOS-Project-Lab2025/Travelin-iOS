//
//  TopHomeView.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 10-12-25.
//

import TravelinDesignSystem
import SwiftUI

struct TopHomeView: View {
    @Binding var searchDetail: SearchDetail
    @Environment(AppRouter.PathRouter<HomeRoutes>.self) private var router
    let screenSize: CGSize
    
    var body: some View {
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
        Text("Explore the world today")
            .foregroundStyle(.white)
            .font(TravelinDesignSystem.DesignTokens.Typography.heading1)
            .padding(.top, TravelinDesignSystem.DesignTokens.Spacing.mediumLarge)
    }
    private var subTitleView: some View {
        (
            Text("Discover ")
                .bold()
            + Text("- take your travel to next level")
        )
        .font(TravelinDesignSystem.DesignTokens.Typography.title2)
        .foregroundStyle(.white)
    }
    private var falseSearchFieldView: some View {
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
    TopHomeView(searchDetail: .constant(SearchDetail()), screenSize: UIScreen.main.bounds.size)
}
