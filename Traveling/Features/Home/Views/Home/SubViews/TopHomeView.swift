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
    @Binding var router: AppRouter.PathRouter<HomeRoutes>
    let screenSize: CGSize
    var body: some View {
        ZStack {
            backgroundImageView
            VStack(alignment: .leading) {
                titleView
                subTitleView
                falseSearchFieldView
                filtersView
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
                .overlay(Color.black.opacity(0.2))
                .clipped()
                .minimumScaleFactor(0.7)
        }
    }
    private var titleView: some View {
        Text("Explore the world today")
            .foregroundStyle(.white)
            .font(.system(size: 48, weight: .bold, design: .default))
            .padding(.top, 24)
    }
    private var subTitleView: some View {
        (
            Text("Discover ")
                .bold()
            + Text("- take your travel to next level")
        )
        .font(.system(size: 16))
        .foregroundStyle(.white)
    }
    private var falseSearchFieldView: some View {
        DSTextField(
            symbolPosition: .right,
            placeHolder: "Search Destination",
            type: .search,
            style: .default,
            text: $searchDetail.searchText)
        .overlay {
            Rectangle()
                .fill(.clear)
                .contentShape(Rectangle())
                .onTapGesture {
                    router.goTo(
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
                variant: .ghost,
                size: .large,
                fullWidth: true,
                fixedWidth: 100
            ) {
                
            }
            Spacer()
            DSButton(
                title: "Oversea",
                icon: Image(systemName: "airplane"),
                iconPosition: .leading,
                variant: .ghost,
                size: .large,
                fullWidth: true,
                fixedWidth: 100
            ) {
                
            }
        }
        .padding(.top)
    }
}

#Preview {
    TopHomeView(searchDetail: .constant(SearchDetail()), router: .constant(AppRouter.PathRouter<HomeRoutes>()), screenSize: UIScreen.main.bounds.size)
}
