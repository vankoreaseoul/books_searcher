//
//  Extension.swift
//  books_searcher
//
//  Created by Heawon Seo on 4/30/25.
//

import Foundation
import CryptoKit

extension NSString {
    func sha256() -> String {
        guard let data = (self as String).data(using: .utf8) else { return self as String }
        let hash = SHA256.hash(data: data)
        return hash.map { String(format: "%02x", $0) }.joined()
    }
}
