//
//  BooksRepository.swift
//  books_searcher
//
//  Created by Heawon Seo on 4/29/25.
//

import Foundation
import Combine

protocol BooksRepository {
    func searchBooks(query: String, page: Int) -> AnyPublisher<BookSearchResponseDTO, ApiError>
}

final class BooksRepositoryImpl: BooksRepository {
    
    func searchBooks(query: String, page: Int) -> AnyPublisher<BookSearchResponseDTO, ApiError> {
        let request = SearchBooksRequest(query: query, page: page)
        return ApiClient.shared.request(request)
    }
}

private struct SearchBooksRequest: ApiRequest {
    var baseURL: URL { URL(string: "https://api.itbook.store/1.0")! }
    var path: String { "/search/\(query)/\(page)" }
    var method: String { "GET" }

    let query: String
    let page: Int
}
