//
//  ImageModel.swift
//  Flickr
//
//  Created by Shashank  on 1/30/25.
//

import Foundation

struct ImageAPIResponse: Decodable {
    let items: [ImageItem]
}

struct ImageItem: Decodable, Hashable {
    let title: String
    let link: String
    let media: ImageURL
    let description: String
    let published: String
    let author: String
    
    var cleanedDescription: String? {
        return description.extractCleanDescription()
    }
    
    var formattedDate: String? {
        return published.toFormattedDate()
    }
    
    var dimensions: String? {
        return description.extractImageDimensions()
    }
}

struct ImageURL: Decodable, Hashable {
    let imageURL: String
    
    enum CodingKeys: String, CodingKey {
        case imageURL = "m"
    }
}

extension ImageAPIResponse {
    
    static let mockImageItems: [ImageItem] = [
        ImageItem(title: "Of course I can dance!",
                  link: "https://www.flickr.com/photos/88642461@N05/51800820813/",
                  media: ImageURL(imageURL: "https://live.staticflickr.com/65535/54296120387_b645da0891_m.jpg"),
                  description: "Female Mallard, Risør, Norway, 13 October 2018",
                  published: "01/30/2025",
                  author: "Gunnar Haug")
    ]
}




