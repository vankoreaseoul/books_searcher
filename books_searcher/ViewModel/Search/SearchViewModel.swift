//
//  SearchViewModel.swift
//  books_searcher
//
//  Created by Heawon Seo on 4/28/25.
//

import Foundation
import Combine

class SearchViewModel {
    
    private var query: String = ""
    
    var books: [Book] = []
    var currentPage: Int = .zero
    var totalPages: Int = .zero
    
    var presentSpinner: (() -> Void)?
    var onUpdate: ((ResultType) -> Void)?
    
    private let searchBooksUsecase: SearchBooksUsecase
    private var cancellables = Set<AnyCancellable>()
    
    init(searchBooksUsecase: SearchBooksUsecase) {
        self.searchBooksUsecase = searchBooksUsecase
        print("SearchViewModel init..")
    }
    
    deinit {
        print("SearchViewModel deinit..")
    }
    
    func didTapSearchBtn(query: String, page: Int) {
        guard !hasSpace(query) else {
            resetComponents(type: .HAS_SPACE)
            return
        }
        
        self.query = query
        
        didTapPageBtn(page: page)
    }
    
    private func hasSpace(_ text: String) -> Bool {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        let hasLeadingOrTrailingSpace = (text != trimmed)

        let hasMiddleSpace = trimmed.contains(" ")

        return hasLeadingOrTrailingSpace || hasMiddleSpace || trimmed.isEmpty
    }
    
    private func resetComponents(type: ResultType) {
        books = []
        currentPage = .zero
        totalPages = .zero
        onUpdate?(type)
    }
    
    func didTapPageBtn(page: Int) {
        presentSpinner?()
        
        searchBooksUsecase.execute(query: query, page: page)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.resetComponents(type: .FAIL)
                    print("[Load Books Fail] Error = \(error), Msg: \(error.errorDescription)")
                    break
                }
            } receiveValue: { [weak self] pagination in
                if let hasPagination = pagination {
                    self?.books = hasPagination.currentBooks
                    self?.currentPage = hasPagination.currentPage
                    self?.totalPages = hasPagination.totalPages
                    self?.onUpdate?(.SUCCESS)
                    
                } else {
                    self?.resetComponents(type: .NO_DATA)
                }
            }
            .store(in: &cancellables)
    }
    
}

enum ResultType {
    case HAS_SPACE
    case FAIL
    case NO_DATA
    case SUCCESS
}
