//
//  Entity.swift
//  books_searcher
//
//  Created by Heawon Seo on 4/29/25.
//

struct Pagination {
    let currentPage: Int
    let totalPages: Int
    let currentBooks: [Book]
}

struct Book: Codable {
    let title: String
    let subtitle: String
    let isbn13: String
    let price: String
    let image: String
    let url: String
}
