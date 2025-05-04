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

struct Book: Codable, BookProtocol {
    let title: String
    let subtitle: String
    let isbn13: String
    let price: String
    let image: String
    let url: String
}

struct BookDetail: Codable, BookProtocol {
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
    
    init(bookDetailResponseDTO: BookDetailResponseDTO) {
        title = bookDetailResponseDTO.title
        subtitle = bookDetailResponseDTO.subtitle
        authors = bookDetailResponseDTO.authors
        publisher = bookDetailResponseDTO.publisher
        isbn10 = bookDetailResponseDTO.isbn10
        isbn13 = bookDetailResponseDTO.isbn13
        pages = bookDetailResponseDTO.pages
        year = bookDetailResponseDTO.year
        rating = bookDetailResponseDTO.rating
        desc = bookDetailResponseDTO.desc
        price = bookDetailResponseDTO.price
        image = bookDetailResponseDTO.image
        url = bookDetailResponseDTO.url
        pdf = bookDetailResponseDTO.pdf
    }
}
