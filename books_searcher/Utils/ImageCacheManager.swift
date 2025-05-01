//
//  ImageCacheManager.swift
//  books_searcher
//
//  Created by Heawon Seo on 4/30/25.
//

import UIKit
import Combine

final class ImageCacheManager {
    
    private let memoryCache = NSCache<NSString, UIImage>()
    private let fileManager = FileManager.default
    private let diskCacheURL: URL
    
    private let booksRepo: BooksRepository

    // 50MB
    private let maxDiskCacheSize: UInt64 = 50 * 1024 * 1024
    // 7 days
    private let cacheExpiration: TimeInterval = 7 * 24 * 60 * 60

    init(booksRepo: BooksRepository) {
        let urls = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
        diskCacheURL = urls[0].appendingPathComponent("ImageCache")
        self.booksRepo = booksRepo
        
        createDiskCacheDirectoryIfNotExist()
    }
    
    private func createDiskCacheDirectoryIfNotExist() {
        guard !fileManager.fileExists(atPath: diskCacheURL.path) else { return }
        try? fileManager.createDirectory(at: diskCacheURL, withIntermediateDirectories: true)
    }
    
    private func loadImageFromMemoryCache(key: NSString) -> UIImage? {
        return memoryCache.object(forKey: key)
    }
    
    private func loadImageFromDiskCache(key: NSString) -> (image: UIImage?, fileURL: URL?) {
        let fileURL = diskCacheURL.appendingPathComponent(key.sha256())
        
        guard let attributes = try? fileManager.attributesOfItem(atPath: fileURL.path), let modDate = attributes[.modificationDate] as? Date, Date().timeIntervalSince(modDate) < cacheExpiration else { return (nil, fileURL) }
        
        guard let data = try? Data(contentsOf: fileURL), let image = UIImage(data: data) else { return (nil, fileURL) }
        
        memoryCache.setObject(image, forKey: key)
        return (image, nil)
    }
    
    private func loadImageFromNetwork(url: String, key: NSString, fileURL: URL) -> AnyPublisher<UIImage, ApiError> {
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

    func loadImage(url: String) -> AnyPublisher<UIImage, ApiError> {
        let key = url as NSString
        
        if let imageFromMemoryCache = loadImageFromMemoryCache(key: key) {
            return Just(imageFromMemoryCache)
                .setFailureType(to: ApiError.self)
                .eraseToAnyPublisher()
        }
        
        let tuple = loadImageFromDiskCache(key: key)
        let image = tuple.image
        let fileURL = tuple.fileURL
        
        if let imageFromDiskCache = image {
            return Just(imageFromDiskCache)
                .setFailureType(to: ApiError.self)
                .eraseToAnyPublisher()
        }
        
        return loadImageFromNetwork(url: url, key: key, fileURL: fileURL!)
    }

    private func enforceDiskLimit() {
        guard let files = try? fileManager.contentsOfDirectory(at: diskCacheURL, includingPropertiesForKeys: [.contentModificationDateKey, .fileSizeKey], options: []) else { return }

        var totalSize: UInt64 = 0
        var fileAttributes: [(url: URL, size: UInt64, date: Date)] = []

        for fileURL in files {
            guard let attr = try? fileURL.resourceValues(forKeys: [.fileSizeKey, .contentModificationDateKey]),
                  let fileSize = attr.fileSize,
                  let modDate = attr.contentModificationDate else { continue }
            totalSize += UInt64(fileSize)
            fileAttributes.append((fileURL, UInt64(fileSize), modDate))
        }

        if totalSize <= maxDiskCacheSize { return }

        let sorted = fileAttributes.sorted { $0.date < $1.date }
        var currentSize = totalSize

        for file in sorted {
            try? fileManager.removeItem(at: file.url)
            currentSize -= file.size
            if currentSize <= maxDiskCacheSize { break }
        }
    }
    
}
