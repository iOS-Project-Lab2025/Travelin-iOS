//
//  ReusablePackageSearchView.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 04-01-26.
//

import SwiftUI

struct ReusablePackageSearchView: View {
    
    @Binding var packages: [Package]
    
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
                                            .onAppear { print("❌ Image error:", error.localizedDescription, urlString) }
                                        
                                    @unknown default:
                                        EmptyView()
                                    }
                                }
                                .frame(width: size.width * 0.38, height: size.width * 0.38)
                                .cornerRadius(15)
                                .clipped()
                                .overlay(Color.black.opacity(Constants.overlayOpacity))
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(package.name)
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
                                        .lineLimit(1)
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
    }
}
