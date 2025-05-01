//
//  BooksRepository.swift
//  books_searcher
//
//  Created by Heawon Seo on 4/29/25.
//

import Foundation
import Combine
import UIKit

protocol BooksRepository {
    
    var apiClient: ApiClient { get }
    
    func searchBooks(query: String, page: Int) -> AnyPublisher<BookSearchResponseDTO, ApiError>
    func loadImage(url: String) -> AnyPublisher<UIImage, ApiError>
}

final class BooksRepositoryImpl: BooksRepository {
    
    var apiClient: ApiClient
    
    init(apiClient: ApiClient) {
        self.apiClient = apiClient
    }
    
    func searchBooks(query: String, page: Int) -> AnyPublisher<BookSearchResponseDTO, ApiError> {
        let request = SearchBooksRequest(query: query, page: page)
        return apiClient.request(request)
    }
    
    func loadImage(url: String) -> AnyPublisher<UIImage, ApiError> {
        let request = LoadImageRequest(imageURL: url)
        return apiClient.requestImage(request)
    }
}

private struct SearchBooksRequest: ApiRequest {
    var baseURL: URL { URL(string: "https://api.itbook.store/1.0")! }
    var path: String { "/search/\(query)/\(page)" }
    var method: String { "GET" }

    let query: String
    let page: Int
}

private struct LoadImageRequest: ApiRequest {
    var baseURL: URL { URL(string: imageURL)! }
    var path: String { "" }
    var method: String { "GET" }
    
    var imageURL: String
}
