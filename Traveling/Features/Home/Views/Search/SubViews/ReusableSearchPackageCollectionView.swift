//
//  ReusablePackageSearchView.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 04-01-26.
//

import SwiftUI

struct ReusableSearchPackageCollectionView: View {
    
    @Binding var packages: [Package]
    @Binding var router: AppRouter.PathRouter<HomeRoutes>
    
    let totalPackage: Int
    let size: CGSize
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(
                alignment: .center,
                spacing: 0) {
                    ForEach(Array(packages.prefix(totalPackage))) { package in
                        VStack {
                            HStack {
                                let urlString = package.imagesCollection.first ?? ""
                                let url = URL(string: urlString)
                                checkPhaseImageView(url: url)
                                VStack(alignment: .leading, spacing: 8) {
                                    packageNameView(name: package.name)
                                    rankingView(rating: package.rating, totalReviews: package.numberReviews)
                                    descriptionView(description: package.description)
                                    priceView(price: package.price)
                                    servicesView(text: package.servicesIncluded.first!.title)
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
                        .onTapGesture {
                            router.goTo(.poiDetail(id: package.id))
                        }
                    }
                }
        }
    }
    @ViewBuilder
    private func checkPhaseImageView(url: URL?) -> some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                ProgressView()
                    .frame(width: size.width * 0.38, height: size.width * 0.38)
                
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
                
            case .failure(let error):
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .padding(24)
                    .foregroundStyle(.gray)
                
            @unknown default:
                EmptyView()
            }
        }
        .frame(width: size.width * 0.38, height: size.width * 0.38)
        .cornerRadius(15)
        .clipped()
        .overlay(Color.black.opacity(Constants.overlayOpacity))
    }
    @ViewBuilder
    private func packageNameView(name: String) -> some View {
        Text(name)
            .foregroundStyle(.primary)
            .font(.system(size: 20, weight: .bold))
            .lineLimit(2)
    }
    @ViewBuilder
    private func rankingView(rating: Int, totalReviews: Int) -> some View {
        HStack(spacing: 0) {
            ForEach(0..<5, id: \.self) { index in
                Image(systemName: "star.fill")
                    .font(.system(size: 14))
                    .foregroundStyle(rating >= index + 1 ? .yellow : .gray)
                
            }
            Text("\(totalReviews)")
                .font(.system(size: 14))
                .foregroundStyle(.primary)
                .padding(.leading)
            
            Text(" reviews")
                .font(.system(size: 14))
                .foregroundStyle(.primary)
        }
    }
    @ViewBuilder
    private func descriptionView(description: String) -> some View {
        Text(description)
            .font(.system(size: 14))
            .foregroundStyle(.primary)
            .lineLimit(1)
    }
    @ViewBuilder
    private func priceView(price: Int) -> some View {
        Text("from $\(price)/person ")
            .foregroundStyle(.primary)
            .font(.system(size: 16, weight: .bold))
    }
    @ViewBuilder
    private func servicesView(text: String) -> some View {
        Text(text)
            .foregroundStyle(.primary)
            .font(.system(size: 16, weight: .medium))
            .padding(.all, 6)
            .overlay {
                RoundedRectangle(cornerRadius: 0)
                    .stroke(Color.gray.opacity(0.8), lineWidth: 1)
            }
    }
}
