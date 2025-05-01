//
//  LoadBookImageUsecase.swift
//  books_searcher
//
//  Created by Heawon Seo on 4/30/25.
//

import Foundation
import Combine
import UIKit

protocol LoadBookImageUsecase {
    
    var imageCacheMgr: ImageCacheManager { get }
    
    func execute(url: String) -> AnyPublisher<UIImage, ApiError>
}

final class LoadBookImageUsecaseImpl: LoadBookImageUsecase {
    
    var imageCacheMgr: ImageCacheManager
    
    init(imageCacheMgr: ImageCacheManager) { self.imageCacheMgr = imageCacheMgr }
    
    func execute(url: String) -> AnyPublisher<UIImage, ApiError> {
        return imageCacheMgr.load(url: url)
    }
}
