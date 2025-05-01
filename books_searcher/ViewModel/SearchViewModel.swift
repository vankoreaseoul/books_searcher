//
//  SearchViewModel.swift
//  books_searcher
//
//  Created by Heawon Seo on 4/28/25.
//

import Foundation
import Combine

class SearchViewModel {
    
    private var searchBooksUsecase: SearchBooksUsecase
    var loadBookImageUsecase: LoadBookImageUsecase
    
    private var cancellables = Set<AnyCancellable>()
    private var query: String = ""
    
    var books: [Book] = []
    var currentPage: Int = .zero
    var totalPages: Int = .zero
    
    var presentAlert: ((String) -> Void)?
    var onUpdate: (() -> Void)?
    
    init(searchBooksUsecase: SearchBooksUsecase, loadBookImageUsecase: LoadBookImageUsecase) {
        self.searchBooksUsecase = searchBooksUsecase
        self.loadBookImageUsecase = loadBookImageUsecase
    }
    
    deinit {
        print("SearchViewModel deinit..")
    }
    
    func didTapSearchBtn(query: String, page: Int) {
        guard !hasSpace(query) else {
            presentAlert?("Spaces are not allowed.\nPlease re-enter without spaces.")
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
    
    func resetComponents() {
        books = []
        currentPage = .zero
        totalPages = .zero
        onUpdate?()
    }
    
    func didTapPageBtn(page: Int) {
        searchBooksUsecase.execute(query: query, page: page)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("[Load Books Fail] Error = \(error), Msg: \(error.errorDescription)")
                    break
                }
            } receiveValue: { [weak self] pagination in
                if let hasPagination = pagination {
                    self?.books = hasPagination.currentBooks
                    self?.currentPage = hasPagination.currentPage
                    self?.totalPages = hasPagination.totalPages
                    self?.onUpdate?()
                    
                } else {
                    // 자료가 없는 경우
                    self?.resetComponents()
                }
            }
            .store(in: &cancellables)
    }
    
}
