//
//  ImageListView.swift
//  Flickr
//
//  Created by Shashank  on 1/30/25.
//

import SwiftUI

struct ImageListView: View {
    
    @StateObject private var viewModel: ImageViewModel
    
    init(viewModel: ImageViewModel? = nil) {
        if let vm = viewModel {
            _viewModel = StateObject(wrappedValue: vm)
        } else {
            _viewModel = StateObject(wrappedValue: ImageViewModel(imageFetcherService: ImageFeedFetcher()))
        }
    }
    
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            GeometryReader { geo in
                let width = geo.size.width
                let itemWidth = width / 3 - 4
                
                let columns = [
                    GridItem(.adaptive(minimum: itemWidth, maximum: itemWidth), spacing: 2)
                ]
                
                VStack {
                    if viewModel.isLoading {
                        ProgressView("Loading Images 🏞️...")
                            .progressViewStyle(CircularProgressViewStyle())
                    } else if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.gray)
                            .padding()
                    } else {
                        ScrollView {
                            LazyVGrid(columns: columns, spacing: 2) {
                                ForEach(viewModel.images, id: \.link) { imageItem in
                                    NavigationLink(value: imageItem) {
                                        ImageGridItem(
                                            imageURL: imageItem.media.imageURL,
                                            width: itemWidth,
                                            height: itemWidth
                                        )
                                    }
                                }
                            }
                            .padding(.horizontal, 2)
                        }
                    }
                }
                .navigationTitle("Images")
                .searchable(text: $viewModel.searchText)
                .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                .navigationDestination(for: ImageItem.self) { imageItem in
                    ImageDetailView(item: imageItem)
                }
            }
        }
    }
}

// MARK: PREVIEW

struct ImageListView_Previews: PreviewProvider {
    static var previews: some View {
        
        let mockImageItems = ImageAPIResponse.mockImageItems
        
        let mockResponse = ImageAPIResponse(items: mockImageItems)
        
        let mockService = MockImageFeedFetcher()
        mockService.mockResult = .success(mockResponse)
        
        let mockViewModel = ImageViewModel(imageFetcherService: mockService)
        
        return ImageListView(viewModel: mockViewModel)
    }
}
