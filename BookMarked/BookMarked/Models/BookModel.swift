////
////  BookModel.swift
////  BookMarked
////
////  Created by Chynna Leigh Alcaide on 2024-07-16.
////

import Foundation

struct BookResponse: Decodable {
    let items: [BookItem]
}

struct BookItem: Decodable {
    let volumeInfo: Book
}

struct Book: Decodable, Identifiable {
    let id: UUID
    let title: String
    let authors: [String]
    var description: String?
    var thumbnail: String?
    var pageCount: Int?
    var dateAdded: Date
    var lastEdited: Date

    enum CodingKeys: String, CodingKey {
        case title
        case authors
        case description
        case imageLinks
        case pageCount
    }

    enum ImageLinksKeys: String, CodingKey {
        case thumbnail
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = UUID()
        title = try container.decode(String.self, forKey: .title)
        authors = try container.decode([String].self, forKey: .authors)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        pageCount = try container.decodeIfPresent(Int.self, forKey: .pageCount)
        
        if let imageLinksContainer = try? container.nestedContainer(keyedBy:ImageLinksKeys.self, forKey: .imageLinks) {
            thumbnail = try imageLinksContainer.decodeIfPresent(String.self, forKey: .thumbnail)
            thumbnail = thumbnail?.replacingOccurrences(of: "http://", with: "https://")
        } else {
            thumbnail = nil
        }
        
        dateAdded = Date()
        lastEdited = Date()
        
        print("thumbnail: " + (thumbnail ?? ""))
        print("pageCount: \(pageCount ?? 0)")
    }
}

struct BookAllData: Identifiable {
    var id: UUID
    var title: String
    var authors: [String]?
    var description: String?
    var thumbnail: String?
    var pageCount: Int?
    var dateAdded: Date?
    var lastEdited: Date?
}
