//
//  SearchTableCellViewModel.swift
//  books_searcher
//
//  Created by Heawon Seo on 5/1/25.
//

import Foundation
import UIKit
import Combine

class SearchTableCellViewModel {
    
    let title: String
    let subtitle: String
    let isbn13: String
    let price: String
    let url: String
    private let imageURL: String
    
    var successLoadImage: ((UIImage) -> Void)?
    var failLoadImage: (() -> Void)?
    
    private let loadBookImageUsecase: LoadBookImageUsecase
    private var cancellables = Set<AnyCancellable>()
    
    init(book: Book, loadBookImageUsecase: LoadBookImageUsecase) {
        title = book.title
        subtitle = book.subtitle
        isbn13 = book.isbn13
        price = book.price
        url = book.url
        imageURL = book.image
        
        self.loadBookImageUsecase = loadBookImageUsecase
        
        print("SearchTableCellViewModel init..")
    }
    
    deinit {
        print("SearchTableCellViewModel deinit..")
    }
    
    func configureImage() {
        guard !imageURL.isEmpty else { return }
        
        loadBookImageUsecase.execute(url: imageURL)
            .sink { [weak self] completion in
                switch completion {
                case.finished:
                    break
                case .failure(let error):
                    self?.failLoadImage?()
                    print("[Load Image Fail at SearchTableCellViewModel] Error: \(error), Msg: \(error.errorDescription)")
                    break
                }
            } receiveValue: { [weak self] image in
                self?.successLoadImage?(image)
            }
            .store(in: &cancellables)
    }
    
    
    
}
