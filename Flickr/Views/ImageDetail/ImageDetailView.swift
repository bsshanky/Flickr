//
//  DetailView.swift
//  Flickr
//
//  Created by Shashank  on 1/29/25.
//

import SwiftUI

struct ImageDetailView: View {
    
    let item: ImageItem
    @State private var showShareView = false
    
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack(spacing: 20) {
                    
                    let itemWidth = min(geo.size.width, geo.size.height)
                    
                    ImageGridItem(
                        imageURL: item.media.imageURL,
                        width: itemWidth,
                        height: 300
                    )
                    
                    HStack {
                        Text(item.title)
                            .font(.title2)
                            .fontWeight(.bold)
                        Spacer()
                    }
                    .padding(.horizontal, 20)

                    sectionView(header: "Description") {
                        HStack {
                            Text(item.cleanedDescription ?? "Description Unavailable")
                            Spacer()
                        }
                    }
                    
                    sectionView(header: "Author") {
                        HStack {
                            Text(item.author)
                            Spacer()
                        }
                    }
                    
                    sectionView(header: "Published Date") {
                        HStack {
                            Text(item.formattedDate ?? "Unknown")
                            Spacer()
                        }
                    }
                    
                    sectionView(header: "Dimensions") {
                        HStack {
                            Text("W x H: \(item.dimensions ?? "Unavailable")")
                            Spacer()
                        }
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .frame(width: geo.size.width, height: geo.size.height, alignment: .top)
        }
        
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showShareView = true
                } label: {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
        
        .sheet(isPresented: $showShareView) {
            ShareImageView(item: item, showShareView: $showShareView)
        }
    }
    
    @ViewBuilder
    private func sectionView<Content: View>(header: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(header)
                .font(.headline)
                .foregroundStyle(Color(uiColor: .systemBlue))
            
            content()
                .padding()
                .background(Color(uiColor: .systemGray5))
                .cornerRadius(10)
        }
        .padding(.horizontal, 15)
    }
}


// MARK: PREVIEW

#Preview {
    NavigationStack {
        ImageDetailView(item: ImageAPIResponse.mockImageItems[0])
    }
    
}
