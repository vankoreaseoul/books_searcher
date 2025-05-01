//
//  DetailViewModel.swift
//  books_searcher
//
//  Created by Heawon Seo on 5/1/25.
//

import Foundation
import UIKit
import Combine

class DetailViewModel {
    
    private let isbn13: String
    
    var successGetBookDetail: ((BookDetail) -> Void)?
    var failGetBookDetail: ((String) -> Void)?
    
    var successGetBookImage: ((UIImage) -> Void)?
    var failGetBookImage: (() -> Void)?
    
    private let getBookDetailUsecase: GetBookDetailUsecase
    private let loadBookImageUsecase: LoadBookImageUsecase
    private let loadBookPDFUsecase: LoadBookPDFUsecase
    
    private var cancellables = Set<AnyCancellable>()
    
    init(book: Book, getBookDetailUsecase: GetBookDetailUsecase, loadBookImageUsecase: LoadBookImageUsecase, loadBookPDFUsecase: LoadBookPDFUsecase) {
        isbn13 = book.isbn13
        self.getBookDetailUsecase = getBookDetailUsecase
        self.loadBookImageUsecase = loadBookImageUsecase
        self.loadBookPDFUsecase = loadBookPDFUsecase
        
        print("DetailViewModel init..")
    }
    
    deinit {
        print("DetailViewModel deinit..")
    }
    
    func getBookDetail() {
        getBookDetailUsecase.execute(isbn13: isbn13)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.failGetBookDetail?("Can't load data..")
                    print("[Load Detail Fail] Error: \(error), Msg: \(error.errorDescription)")
                    break
                }
            } receiveValue: { [weak self] detail in
                self?.successGetBookDetail?(detail)
                self?.loadImage(imageURL: detail.image)
                
//                guard let pdfList = detail.pdf, !pdfList.isEmpty else { return }
                let pdfList = ["Chapter 2": "https://itbook.store/files/9781617294136/chapter2.pdf",
                               "Chapter 5": "https://itbook.store/files/9781617294136/chapter5.pdf"]
                
                
                self?.loadPDFs(pdfs: pdfList)
            }
            .store(in: &cancellables)
    }
    
    private func loadImage(imageURL: String) {
        guard !imageURL.isEmpty else {
            failGetBookImage?()
            return
        }
        
        loadBookImageUsecase.execute(url: imageURL)
            .sink { [weak self] completion in
                switch completion {
                case.finished:
                    break
                case .failure(let error):
                    self?.failGetBookImage?()
                    print("[Load Image Fail at DetailViewModel] Error: \(error), Msg: \(error.errorDescription)")
                    break
                }
            } receiveValue: { [weak self] image in
                self?.successGetBookImage?(image)
            }
            .store(in: &cancellables)
    }
    
    private func loadPDFs(pdfs: [String: String]) {
        pdfs.forEach { (key: String, url: String) in
            loadBookPDFUsecase.execute(url: url)
                .sink { [weak self] completion in
                    switch completion {
                    case.finished:
                        break
                    case .failure(let error):
                        
                        print("[Load PDF Fail] Error: \(error), Msg: \(error.errorDescription)")
                        break
                    }
                } receiveValue: { [weak self] pdfDocument in
                    print("result = \(pdfDocument)")
                }
                .store(in: &cancellables)
        }
    }
    
}
