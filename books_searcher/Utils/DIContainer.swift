//
//  DIContainer.swift
//  books_searcher
//
//  Created by Heawon Seo on 4/30/25.
//

import Foundation

final class DIContainer {
    
    private var booksRepository: BooksRepository
    
    init() {
        let apiClient = ApiClient()
        booksRepository = BooksRepositoryImpl(apiClient: apiClient)
    }
    
    func makeSearchViewModel() -> SearchViewModel {
        let searchBooksUsecase = SearchBooksUsecaseImpl(booksRepo: booksRepository)
        let loadBookImageUsecase = LoadBookImageUsecaseImpl(imageCacheMgr: ImageCacheManager(booksRepo: booksRepository))
        return SearchViewModel(searchBooksUsecase: searchBooksUsecase, loadBookImageUsecase: loadBookImageUsecase)
    }
    
}
