//
//  ImageGridItemView.swift
//  Flickr
//
//  Created by Shashank  on 1/30/25.
//

import SwiftUI

struct ImageGridItem: View {
    let imageURL: String
    let width: CGFloat
    let height: CGFloat

    var body: some View {
        VStack {
            if let url = URL(string: imageURL) {
                CacheAsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        Color.gray.opacity(0.3)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: width, height: height)
                            .clipped()
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .frame(width: width, height: height)
                            .foregroundColor(.gray)
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(width: width, height: height)
            }
        }
    }
}
