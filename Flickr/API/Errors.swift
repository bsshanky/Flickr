//
//  Errors.swift
//  Flickr
//
//  Created by Shashank  on 1/30/25.
//

import Foundation

enum APIError: Error, CustomStringConvertible {
    
    case badURL
    case badResponse(statusCode: Int)
    case parsing(DecodingError?)
    case unknown
    
    var localizedDescription: String {
        switch self {
        case .unknown:
            return "Unexpected error occurred."
        case .badURL:
            return "Cannot reach server."
        case .parsing(_):
            return "Unable to fetch data."
        case .badResponse(let statusCode):
            return "Bad response \(statusCode)"
        }
    }
    
    var description: String {
        switch self {
        case .unknown: return "unknown error"
        case .badURL: return "invalid URL"
        case .parsing(let error):
            return "parsing error: \(error?.localizedDescription ?? "")"
        case .badResponse(let statusCode):
            return "bad response; status code \(statusCode)"
        }
    }
}
