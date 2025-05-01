//
//  LoadBookPDFUsecase.swift
//  books_searcher
//
//  Created by Heawon Seo on 5/2/25.
//

import Foundation
import Combine
import PDFKit

protocol LoadBookPDFUsecase {
    
    var pdfCacheMgr: PDFCacheManager { get }
    
    func execute(url: String) -> AnyPublisher<PDFDocument, ApiError>
}

final class LoadBookPDFUsecaseImpl: LoadBookPDFUsecase {
    
    var pdfCacheMgr: PDFCacheManager
    
    init(pdfCacheMgr: PDFCacheManager) { self.pdfCacheMgr = pdfCacheMgr }
    
    func execute(url: String) -> AnyPublisher<PDFDocument, ApiError> {
        return pdfCacheMgr.load(url: url)
    }
}
