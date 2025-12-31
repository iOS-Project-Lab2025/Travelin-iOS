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
    
    let screenSize: CGSize
    var body: some View {
        ZStack {
            Image("principalHome")
                .resizable()
                .scaledToFill()
                .frame(width: screenSize.width, height: screenSize.height * 0.45)
                .overlay(Color.black.opacity(0.2))
                .clipped()
                .minimumScaleFactor(0.7)
            VStack(alignment: .leading) {
                Text("Explore the world today")
                    .foregroundStyle(.white)
                    .font(.system(size: 48, weight: .bold, design: .default))
                    .padding(.top, 24)
                (
                    Text("Discover ")
                        .bold()
                    + Text("- take your travel to next level")
                )
                .font(.system(size: 16))
                .foregroundStyle(.white)
                DSTextField(
                    symbolPosition: .right,
                    placeHolder: "Search Destination",
                    type: .search,
                    style: .default,
                    text: $searchDetail.searchText) {

                    }
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
            .padding()
        }
    }
}

#Preview {
    TopHomeView(searchDetail: .constant(SearchDetail()), screenSize: UIScreen.main.bounds.size)
}
