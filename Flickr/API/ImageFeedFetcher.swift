//
//  ImageFeedFetcher.swift
//  Flickr
//
//  Created by Shashank  on 1/30/25.
//

import Foundation

protocol ImageFeedProtocol {
    func fetchImages(tags: String) async throws -> ImageAPIResponse
}

final class ImageFeedFetcher: ImageFeedProtocol {

    func fetchImages(tags: String) async throws -> ImageAPIResponse {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = APIConstants.scheme
        urlComponents.host = APIConstants.host
        urlComponents.path = APIConstants.path
        urlComponents.queryItems = [
            URLQueryItem(name: "format", value: APIConstants.format),
            URLQueryItem(name: "nojsoncallback", value: APIConstants.callback),
            URLQueryItem(name: "tags", value: tags)
        ]

        guard let url = urlComponents.url else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw APIError.badResponse(statusCode: (response as? HTTPURLResponse)?.statusCode ?? -1)
        }
        
        do {
            // Decode the JSON data into the desired model
            let responseModel = try JSONDecoder().decode(ImageAPIResponse.self, from: data)
            return responseModel
        } catch let decodingError as DecodingError {
            throw APIError.parsing(decodingError)
        } catch {
            throw APIError.unknown
        }
    }
}

final class MockImageFeedFetcher: ImageFeedProtocol {
    var mockResult: Result<ImageAPIResponse, Error>?

    func fetchImages(tags: String) async throws -> ImageAPIResponse {
        if let result = mockResult {
            switch result {
            case .success(let model): return model
            case .failure(let error): throw error
            }
        }
        throw NSError(domain: "MockError", code: -1, userInfo: nil)
    }
}
