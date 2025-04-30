//
//  ResponseDTO.swift
//  books_searcher
//
//  Created by Heawon Seo on 4/29/25.
//

struct BookSearchResponseDTO: Codable {
    let error: String
    let total: String
    let page: String?
    let books: [Book]
}
