//
//  GetBookDetailUsecase.swift
//  books_searcher
//
//  Created by Heawon Seo on 5/1/25.
//

import Foundation
import Combine

protocol GetBookDetailUsecase {
    
    var booksRepo: BooksRepository { get }
    
    func execute(isbn13: String) -> AnyPublisher<BookDetail, ApiError>
}


class GetBookDetailUsecaseImpl: GetBookDetailUsecase {
    
    var booksRepo: BooksRepository
    
    init(booksRepo: BooksRepository) { self.booksRepo = booksRepo }
    
    func execute(isbn13: String) -> AnyPublisher<BookDetail, ApiError> {
        booksRepo.getBookDetail(isbn13: isbn13)
            .tryMap { bookDetailResponseDTO -> BookDetail in
                return BookDetail(bookDetailResponseDTO: bookDetailResponseDTO)
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
