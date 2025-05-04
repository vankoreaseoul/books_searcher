//
//  ImageCacheManager.swift
//  books_searcher
//
//  Created by Heawon Seo on 4/30/25.
//

import UIKit
import Combine

final class ImageCacheManager: CacheManager<UIImage> {
    
    private let booksRepo: BooksRepository

    init(booksRepo: BooksRepository) {
        self.booksRepo = booksRepo
        
        let fileMgr = FileManager.default
        let urls = fileMgr.urls(for: .cachesDirectory, in: .userDomainMask)
        let diskCacheURL = urls[0].appendingPathComponent("ImageCache")
        
        super.init(fileManager: fileMgr, diskCacheURL: diskCacheURL, cacheExpiration: 7 * 24 * 60 * 60, maxDiskCacheSize: 50 * 1024 * 1024)
    }
    
    override func loadFromDiskCache(key: NSString) -> (image: UIImage?, fileURL: URL?) {
        let fileURL = diskCacheURL.appendingPathComponent(key.sha256())
        
        guard let attributes = try? fileManager.attributesOfItem(atPath: fileURL.path), let modDate = attributes[.modificationDate] as? Date, Date().timeIntervalSince(modDate) < cacheExpiration else { return (nil, fileURL) }
        
        guard let data = try? Data(contentsOf: fileURL), let image = UIImage(data: data) else { return (nil, fileURL) }
        
        memoryCache.setObject(image, forKey: key)
        return (image, nil)
    }
    
    override func loadFromNetwork(url: String, key: NSString, fileURL: URL) -> AnyPublisher<UIImage, ApiError> {
        return booksRepo.loadImage(url: url)
            .tryMap { [weak self] image in
                self?.memoryCache.setObject(image, forKey: key)
                try? image.pngData()?.write(to: fileURL, options: .atomic)
                self?.enforceDiskLimit()
                
                return image
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
