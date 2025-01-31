//
//  SearchViewModel.swift
//  Flickr
//
//  Created by Shashank  on 1/29/25.
//

import SwiftUI
import Combine

@MainActor
final class ImageViewModel: ObservableObject {
    
    @Published var searchText: String = ""
    @Published var images: [ImageItem] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let imageFetcherService: ImageFeedProtocol
    
    private var cancellables = Set<AnyCancellable>()

    init(imageFetcherService: ImageFeedProtocol) {
        self.imageFetcherService = imageFetcherService

        $searchText
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .sink { [weak self] newText in
                guard let self = self, !newText.trimmingCharacters(in: .whitespaces).isEmpty else { return }
                Task { await self.search(for: newText) }
            }
            .store(in: &cancellables)
    }

    func search(for tags: String) async {
        guard !tags.isEmpty else {
            images = []
            return
        }
        do {
            isLoading = true
            errorMessage = nil

            let normalizedTags = tags.replacingOccurrences(of: " ", with: ",")

            let feed = try await imageFetcherService.fetchImages(tags: normalizedTags)
            images = feed.items
            
            if images.isEmpty {
                errorMessage = "No results found :("
            }
            
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
