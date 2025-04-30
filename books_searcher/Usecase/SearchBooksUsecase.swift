//
//  SearchBooksUsecase.swift
//  books_searcher
//
//  Created by Heawon Seo on 4/29/25.
//

import Combine

protocol SearchBooksUsecase {
    func execute(query: String, page: Int) -> AnyPublisher<Pagination?, ApiError>
}

final class SearchBooksUsecaseImpl: SearchBooksUsecase {
    
    private let bookRepo: BooksRepository = BooksRepositoryImpl()
    
    func execute(query: String, page: Int) -> AnyPublisher<Pagination?, ApiError> {
        bookRepo.searchBooks(query: query, page: page)
            .tryMap { bookSearchResponseDTO -> Pagination? in
                guard let hasPage = bookSearchResponseDTO.page, let pageNum = Int(hasPage), pageNum != .zero, !bookSearchResponseDTO.books.isEmpty, let total = Int(bookSearchResponseDTO.total), total != 0 else { return nil }
                let pageCount = total / 10 + (total % 10 == 0 ? 0 : 1)
                return Pagination(currentPage: page, totalPages: pageCount, currentBooks: bookSearchResponseDTO.books)
            }
            .mapError { error in
                if let apiError = error as? ApiError {
                    return apiError
                } else {
                    return .unknown
                }
            }
            .eraseToAnyPublisher()
    }
    
}
