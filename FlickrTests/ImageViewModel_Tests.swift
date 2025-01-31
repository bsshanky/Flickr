//
//  ImageViewModel_Tests.swift
//  FlickrTests
//
//  Created by Shashank  on 1/30/25.
//

import XCTest
import Combine
@testable import Flickr

extension ImageItem {
    static let mockItem = ImageItem(
        title: "Sunset",
        link: "https://example.com",
        media: ImageURL(imageURL: "https://example.com/sunset.jpg"),
        description: "Beautiful Sunset",
        published: "2025-01-30T18:13:43Z",
        author: "Photographer"
    )
}

final class ImageViewModel_Tests: XCTestCase {
    
    var viewModel: ImageViewModel!
    var mockService: MockImageFeedFetcher!
    var cancellables: Set<AnyCancellable>!

    override func setUp() async throws {
        try await super.setUp()

        mockService = MockImageFeedFetcher()
        viewModel = await ImageViewModel(imageFetcherService: mockService)
        cancellables = []
    }

    override func tearDownWithError() throws {
        viewModel = nil
        mockService = nil
        cancellables = nil
        try super.tearDownWithError()
    }
    
    @MainActor
    func test_ImageViewModel_InitialState_ValuesAreCorrect() {
        // Given: A newly initialized ViewModel
        // When: No interaction has happened yet
        // Then: Expect default state values
        XCTAssertEqual(viewModel.searchText, "", "searchText should start as empty")
        XCTAssertTrue(viewModel.images.isEmpty, "Images should start empty")
        XCTAssertFalse(viewModel.isLoading, "isLoading should start as false")
        XCTAssertNil(viewModel.errorMessage, "errorMessage should start as nil")
    }
    
    @MainActor
    func test_ImageViewModel_Search_SuccessfulFetch() async {
        // Given: A valid search term
        mockService.mockResult = .success(ImageAPIResponse(items: [ImageItem.mockItem]))

        // When: The search function is called
        await viewModel.search(for: "Nature")

        // Then: Images should be loaded
        XCTAssertFalse(viewModel.images.isEmpty, "Images should be populated")
        XCTAssertNil(viewModel.errorMessage, "No error should be set")
    }
    
    @MainActor
    func test_ImageViewModel_Search_EmptyInput() async {
        // Given: An empty search term
        // When: The search function is called
        await viewModel.search(for: "")

        // Then: Images array should be empty
        XCTAssertTrue(viewModel.images.isEmpty, "Images should be empty when search is empty")
    }
    
    @MainActor
    func test_ImageViewModel_Search_NoResults() async {
        // Given: A valid search term but the API returns an empty response
        mockService.mockResult = .success(ImageAPIResponse(items: []))

        // When: The search function is called
        await viewModel.search(for: "RandomQuery")

        // Then: Should show no results message
        XCTAssertTrue(viewModel.images.isEmpty, "Images should be empty when no results are found")
        XCTAssertEqual(viewModel.errorMessage, "No results found :(", "Error message should indicate no results")
    }
    
    @MainActor
    func test_ImageViewModel_isLoading_ChangesCorrectly() async {
        // Given: A valid search term
        mockService.mockResult = .success(ImageAPIResponse(items: [ImageItem.mockItem]))

        // When: Calling search
        let expectation = XCTestExpectation(description: "isLoading changes")

        viewModel.$isLoading
            .dropFirst()
            .sink { isLoading in
                if isLoading {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        await viewModel.search(for: "Beaches")

        // Then: isLoading should have changed at least once
        await fulfillment(of: [expectation], timeout: 1.0)
        XCTAssertFalse(viewModel.isLoading, "isLoading should be false after search completes")
    }
}
