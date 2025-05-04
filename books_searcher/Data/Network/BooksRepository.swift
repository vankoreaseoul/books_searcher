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
    func getBookDetail(isbn13: String) -> AnyPublisher<BookDetailResponseDTO, ApiError>
}

final class BooksRepositoryImpl: BooksRepository {
    
    var apiClient: ApiClient
    
    init(apiClient: ApiClient) { self.apiClient = apiClient }
    
    func searchBooks(query: String, page: Int) -> AnyPublisher<BookSearchResponseDTO, ApiError> {
        let request = SearchBooksRequest(query: query, page: page)
        return apiClient.request(request)
    }
    
    func loadImage(url: String) -> AnyPublisher<UIImage, ApiError> {
        let request = LoadImageRequest(imageURL: url)
        return apiClient.requestImage(request)
    }
    
    func getBookDetail(isbn13: String) -> AnyPublisher<BookDetailResponseDTO, ApiError> {
        let request = BookDetailRequest(isbn13: isbn13)
        return apiClient.request(request)
    }
}

private struct SearchBooksRequest: ApiRequest {
    var baseURL: URL { URL(string: BASE_URL)! }
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

private struct BookDetailRequest: ApiRequest {
    var baseURL: URL { URL(string: BASE_URL)! }
    var path: String { "/books/\(isbn13)" }
    var method: String { "GET" }
    
    var isbn13: String
}
