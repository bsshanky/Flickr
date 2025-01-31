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
    
    let columns: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 2), count: 3)
    
    var body: some View {
        NavigationStack(path: $path) {
                
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
                                    ImageGridItem(imageURL: imageItem.media.imageURL,
                                                  width: UIScreen.main.bounds.width / 3 - 4,
                                                  height: UIScreen.main.bounds.width / 3 - 4)
                                }
                            }
                        }
                        .padding(.horizontal, 2)
                    }
                }
            }
            .navigationTitle("Images")
            .searchable(text: $viewModel.searchText)
            .navigationDestination(for: ImageItem.self) { imageItem in
                ImageDetailView(item: imageItem)
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
