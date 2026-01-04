//
//  wishListView.swift
//  Traveling
//
//  Created by NVSH on 03-01-26.
//

import SwiftUI

struct WishListView: View {
    var body: some View {
        VStack{
            Text("Wishlist")
                .font(.title)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    WishListView()
}
