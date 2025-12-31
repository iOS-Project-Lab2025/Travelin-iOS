//
//  SearchView.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 30-12-25.
//

import SwiftUI
import TravelinDesignSystem

struct SearchView: View {
    @Binding var packages: [Package]
    @Binding var inputText: String
    let size: CGSize
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Rectangle()
                .fill(Color.gray.opacity(0.8))
                .frame(height: 1 )
                .frame(maxWidth:  size.width)
                .padding(inputText.isEmpty ? .bottom : .top)
                
            if inputText.isEmpty {
                NearbySearchComponentView()
                
            } else {
                VStack(alignment: .leading) {
                    ReusablePackageSearchView(inputText: $inputText, packages: $packages, size: size)
                    if packages.count > 3 {
                        Button {
                            
                        } label: {
                            Text("Show + \(packages.count - 3) more available")
                                .foregroundStyle(.black)
                                .font(.system(size: 14, weight: .bold))
                        }
                        .padding()
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.8), lineWidth: 2)
                        }
                        .padding()
                    }
                }
                
            }
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.large)
        //.toolbarBackground(Color.black, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    // acción: menú/ubicación/etc
                } label: {
                    Image(systemName: "chevron.left")
                        .bold()
                        .foregroundStyle(.black)
                }
                .padding(.vertical)
                .padding(.top)
            }
            ToolbarItem(placement: .principal) {
                if inputText.isEmpty {
                    DSTextField(
                        symbolPosition: .left,
                        placeHolder: "Where do you plan to go?",
                        type: .search,
                        style: .outlined,
                        text: $inputText) {
                            
                        }
                        .padding(.vertical)
                        .padding(.top)
                } else {
                    HStack {
                        DSTextField(
                            symbolPosition: .right,
                            type: .search,
                            style: .outlined,
                            text: $inputText) {
                                
                            }
                           
                        Image(systemName: "square.grid.3x2.fill")
                            .font(.system(size: 16))
                            .rotationEffect(Angle(degrees: 90))
                            .foregroundStyle(.primary)
                            
                    }
                    .padding(.vertical)
                    .padding(.top)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        SearchView(packages: .constant([
            Package(
                id: UUID(),
                imageURL: "package1",
                imagesCollection: [],
                name: "Koh Rong Samloem",
                rating: 3,
                numberReviews: 50,
                description: "Lorem ipsum dolor sit amet...",
                isFavorite: true,
                price: 600,
                servicesIncluded: [ServicesIncluded(id: UUID(), title: "2 day 1 night", subTitle: "Duration", icon: "clock.fill")]
            ), Package(
                id: UUID(),
                imageURL: "package1",
                imagesCollection: [],
                name: "Koh Rong Samloem",
                rating: 4,
                numberReviews: 90,
                description: "Lorem ipsum dolor sit amet...",
                isFavorite: true,
                price: 600,
                servicesIncluded: [ServicesIncluded(id: UUID(), title: "2 day 1 night", subTitle: "Duration", icon: "clock.fill")]
            ),
            Package(
                id: UUID(),
                imageURL: "package1",
                imagesCollection: [],
                name: "Koh Rong Samloem",
                rating: 3,
                numberReviews: 50,
                description: "Lorem ipsum dolor sit amet...",
                isFavorite: true,
                price: 600,
                servicesIncluded: [ServicesIncluded(id: UUID(), title: "2 day 1 night", subTitle: "Duration", icon: "clock.fill")]
            ),
            Package(
                id: UUID(),
                imageURL: "package1",
                imagesCollection: [],
                name: "Koh Rong Samloem",
                rating: 4,
                numberReviews: 90,
                description: "Lorem ipsum dolor sit amet...",
                isFavorite: true,
                price: 600,
                servicesIncluded: [ServicesIncluded(id: UUID(), title: "2 day 1 night", subTitle: "Duration", icon: "clock.fill")]
            )
        ]), inputText: .constant("s")
            , size: CGSize(width: UIScreen.main.bounds.width , height: UIScreen.main.bounds.width * 0.38))
    }
}







struct NearbySearchComponentView: View {
    var body: some View {
            Button {
                
            } label: {
                VStack(spacing:0) {
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
                    Rectangle()
                        .fill(Color.gray.opacity(0.8))
                        .frame(height: 1 / UIScreen.main.scale)
                        .padding(.all)
                }
                // Un color por capa
            }
            .padding()
    }
}

struct ReusablePackageSearchView: View {
    @Binding var inputText: String
    @Binding var packages: [Package]
    let size: CGSize
    var body: some View {
        VStack {
            Text("Place name \"\(inputText)\" ")
                .foregroundStyle(.primary)
                .font(.system(size: 20, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.top)
            LazyVStack(
                alignment: .center,
                spacing: 0) {
                    ForEach(Array(packages.prefix(3))) { package in
                        VStack {
                            HStack {
                                Image(package.imageURL)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: size.width * 0.38, height: size.width * 0.38)
                                    .cornerRadius(15)
                                    .clipped()
                                    .overlay(Color.black.opacity(Constants.overlayOpacity))
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Search place nearby place nearby")
                                        .foregroundStyle(.primary)
                                    
                                        .font(.system(size: 20, weight: .bold))
                                        .lineLimit(2)
                                    HStack(spacing: 0) {
                                        ForEach(0..<5, id: \.self) { index in
                                            Image(systemName: "star.fill")
                                                .font(.system(size: 14))
                                                .foregroundStyle(package.rating >= index + 1 ? .yellow : .gray)
                                            
                                        }
                                        Text("\(package.numberReviews)")
                                            .font(.system(size: 14))
                                            .foregroundStyle(.primary)
                                            .padding(.leading)
                                        
                                        Text(" reviews")
                                            .font(.system(size: 14))
                                            .foregroundStyle(.primary)
                                    }
                                    Text(package.description)
                                    
                                        .font(.system(size: 14))
                                        .foregroundStyle(.primary)
                                    Text("from $\(package.price)/person ")
                                    
                                        .foregroundStyle(.primary)
                                        .font(.system(size: 16, weight: .bold))
                                    Text(package.servicesIncluded.first!.title)
                                        .foregroundStyle(.primary)
                                        .font(.system(size: 16, weight: .medium))
                                        .padding(.all, 6)
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 0)
                                                .stroke(Color.gray.opacity(0.8), lineWidth: 1)
                                        }
                                }
                                .frame(maxHeight: .infinity, alignment: .top)
                            }
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            Rectangle()
                                .fill(Color.gray.opacity(0.8))
                                .frame(height: 1)
                                .frame(maxWidth:  size.width)
                                .padding(.vertical, 8)
                        }
                    }
                }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

