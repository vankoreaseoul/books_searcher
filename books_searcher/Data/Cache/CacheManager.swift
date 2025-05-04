//
//  CacheManager.swift
//  books_searcher
//
//  Created by Heawon Seo on 5/1/25.
//

import Foundation
import UIKit
import PDFKit
import Combine

protocol CacheManagerProtocol {
    associatedtype ResourceType: AnyObject
    
    var memoryCache: NSCache<NSString, ResourceType> { get }
    var fileManager: FileManager { get }
    var diskCacheURL: URL { get }
}

class CacheManager<ResourceType: AnyObject>: CacheManagerProtocol {
    
    let memoryCache: NSCache<NSString, ResourceType>
    let fileManager: FileManager
    let diskCacheURL: URL
    
    let cacheExpiration: TimeInterval
    private let maxDiskCacheSize: UInt64
    
    init(fileManager: FileManager, diskCacheURL: URL, cacheExpiration: TimeInterval, maxDiskCacheSize: UInt64) {
        memoryCache = NSCache<NSString, ResourceType>()
        self.fileManager = fileManager
        self.diskCacheURL = diskCacheURL
        self.cacheExpiration = cacheExpiration
        self.maxDiskCacheSize = maxDiskCacheSize
        
        createDiskCacheDirectoryIfNotExist()
    }
    
    private func createDiskCacheDirectoryIfNotExist() {
        guard !fileManager.fileExists(atPath: diskCacheURL.path) else { return }
        try? fileManager.createDirectory(at: diskCacheURL, withIntermediateDirectories: true)
    }
    
    private func loadFromMemoryCache(key: NSString) -> ResourceType? {
        return memoryCache.object(forKey: key)
    }
    
    func loadFromDiskCache(key: NSString) -> (object: ResourceType?, fileURL: URL?) {
        fatalError("Must override")
    }
    
    func loadFromNetwork(url: String, key: NSString, fileURL: URL) -> AnyPublisher<ResourceType, ApiError> {
        fatalError("Must override")
    }

    func load(url: String) -> AnyPublisher<ResourceType, ApiError> {
        let key = url as NSString
        
        if let objFromMemoryCache = loadFromMemoryCache(key: key) {
            return Just(objFromMemoryCache).setFailureType(to: ApiError.self).eraseToAnyPublisher()
        }
        
        let tuple = loadFromDiskCache(key: key)
        let obj = tuple.object
        let fileURL = tuple.fileURL
        
        if let objFromDiskCache = obj {
            return Just(objFromDiskCache).setFailureType(to: ApiError.self).eraseToAnyPublisher()
        }
        
        return loadFromNetwork(url: url, key: key, fileURL: fileURL!)
    }

    func enforceDiskLimit() {
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
