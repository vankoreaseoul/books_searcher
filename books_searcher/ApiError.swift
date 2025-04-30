//
//  ApiError.swift
//  books_searcher
//
//  Created by Heawon Seo on 4/29/25.
//

import Foundation

enum ApiError: LocalizedError {
    case invalidURL
    case responseError(res: HTTPURLResponse)
    case decodingError
    case networkError(Error)
    case unknown
    case selfDeallocated
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "URL is wrong."
        case .responseError(let res):
            return "Server Error (Status Code: \(res.statusCode), Msg: \(res.description))"
        case .decodingError:
            return "Data Parsing fails."
        case .networkError(let error):
            return "Network Error: \(error.localizedDescription)"
        case .unknown:
            return "Unknown Error"
        case .selfDeallocated:
            return nil
        }
    }
}
