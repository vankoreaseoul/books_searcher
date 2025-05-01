//
//  DIContainer.swift
//  books_searcher
//
//  Created by Heawon Seo on 4/30/25.
//

import Foundation
import UIKit

final class DIContainer {
    
    static let shared = DIContainer()
    
    private var booksRepository: BooksRepository
    private var imageCacheManager: ImageCacheManager
    private var pdfCacheManager: PDFCacheManager
    
    private init() {
        let apiClient = ApiClient()
        booksRepository = BooksRepositoryImpl(apiClient: apiClient)
        imageCacheManager = ImageCacheManager(booksRepo: booksRepository)
        pdfCacheManager = PDFCacheManager()
    }
    
    func makeSearchViewModel() -> SearchViewModel {
        let searchBooksUsecase = SearchBooksUsecaseImpl(booksRepo: booksRepository)
        return SearchViewModel(searchBooksUsecase: searchBooksUsecase)
    }
    
    func makeSearchTableCellViewModel(book: Book) -> SearchTableCellViewModel {
        let loadBookImageUsecase = LoadBookImageUsecaseImpl(imageCacheMgr: imageCacheManager)
        return SearchTableCellViewModel(book: book, loadBookImageUsecase: loadBookImageUsecase)
    }
    
    func makeDetailViewModel(book: Book) -> DetailViewModel {
        let getBookDetailUsecase = GetBookDetailUsecaseImpl(booksRepo: booksRepository)
        let loadBookImageUsecase = LoadBookImageUsecaseImpl(imageCacheMgr: imageCacheManager)
        let loadBookPDFUsecase = LoadBookPDFUsecaseImpl(pdfCacheMgr: pdfCacheManager)
        return DetailViewModel(book: book, getBookDetailUsecase: getBookDetailUsecase, loadBookImageUsecase: loadBookImageUsecase, loadBookPDFUsecase: loadBookPDFUsecase)
    }
    
}
