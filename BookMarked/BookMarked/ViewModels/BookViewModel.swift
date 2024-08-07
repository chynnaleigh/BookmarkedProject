//
//  BookViewModel.swift
//  BookMarked
//
//  Created by Chynna Leigh Alcaide on 2024-07-16.
//

import Foundation
import Combine

class BookViewModel: ObservableObject {
    @Published var books: [Book] = []
    private let bookService = BookService()
    
    func fetchBooks(query: String) {
        bookService.fetchBooks(query: query) { [weak self] books in
            guard let self = self, let books = books else { return }
            DispatchQueue.main.async {
                self.books = books
            }
        }
    }
}

