//
//  ResponseDTO.swift
//  books_searcher
//
//  Created by Heawon Seo on 4/29/25.
//

protocol BookResponseDTO {
    var error: String { get }
}

protocol BookProtocol {
    var title: String { get }
    var subtitle: String { get }
    var isbn13: String { get }
    var price: String { get }
    var image: String { get }
    var url: String { get }
}

struct BookSearchResponseDTO: Codable, BookResponseDTO {
    let error: String
    let total: String
    let page: String?
    let books: [Book]
}

struct BookDetailResponseDTO: Codable, BookResponseDTO, BookProtocol {
    let error: String
    let title: String
    let subtitle: String
    let authors: String
    let publisher: String
    let isbn10: String
    let isbn13: String
    let pages: String
    let year: String
    let rating: String
    let desc: String
    let price: String
    let image: String
    let url: String
    let pdf: [String: String]?
}
