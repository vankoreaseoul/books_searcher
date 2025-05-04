//
//  PDFCacheManager.swift
//  books_searcher
//
//  Created by Heawon Seo on 5/1/25.
//

import Foundation
import PDFKit
import Combine

final class PDFCacheManager: CacheManager<PDFDocument> {
    
    init() {
        let fileMgr = FileManager.default
        let diskCacheURL = fileMgr.temporaryDirectory.appendingPathComponent("PDFCache", isDirectory: true)
        
        super.init(fileManager: fileMgr, diskCacheURL: diskCacheURL, cacheExpiration: 7 * 24 * 60 * 60, maxDiskCacheSize: 100 * 1024 * 1024)
    }
    
    override func loadFromDiskCache(key: NSString) -> (image: PDFDocument?, fileURL: URL?) {
        let fileURL = diskCacheURL.appendingPathComponent(key.sha256())
        
        guard let attributes = try? fileManager.attributesOfItem(atPath: fileURL.path), let modDate = attributes[.modificationDate] as? Date, Date().timeIntervalSince(modDate) < cacheExpiration else { return (nil, fileURL) }
        
        guard let data = try? Data(contentsOf: fileURL), let pdfDocument = PDFDocument(data: data) else { return (nil, fileURL) }
        
        memoryCache.setObject(pdfDocument, forKey: key)
        return (pdfDocument, nil)
    }
    
    override func loadFromNetwork(url: String, key: NSString, fileURL: URL) -> AnyPublisher<PDFDocument, ApiError> {
        guard let newURL = URL(string: url) else { return Fail(error: ApiError.invalidURL).eraseToAnyPublisher() }
        guard let pdfDocument = PDFDocument(url: newURL) else { return Fail(error: ApiError.decodingError).eraseToAnyPublisher() }
        
        memoryCache.setObject(pdfDocument, forKey: key)
        try? pdfDocument.dataRepresentation()?.write(to: fileURL, options: .atomic)
        enforceDiskLimit()
        
        return Just(pdfDocument).setFailureType(to: ApiError.self).eraseToAnyPublisher()
    }
    
}
