//
//  BookService.swift
//  BookMarked
//
//  Created by Chynna Leigh Alcaide on 2024-07-16.
//

import Foundation

class BookService {
    func fetchBooks(query: String, completion: @escaping ([Book]?) -> Void) {
        let key = "AIzaSyB_lqHlrjhSM-vj-p1-C5_YTLXbd5YgMis"
        let queryEncoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        let urlString = "https://www.googleapis.com/books/v1/volumes?q=\(queryEncoded)&key=\(key)"
        print("Fetching books with query: \(query)")
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
            
            do {
                let bookResponse = try JSONDecoder().decode(BookResponse.self, from: data)
                let books = bookResponse.items.map { $0.volumeInfo }
                completion(books)
            } catch {
                print("Error decoding data: \(error.localizedDescription)")
                completion(nil)
            }
            print("Received data: \(data)")
            print("Error: \(error?.localizedDescription ?? "None")")

        }.resume()
    }
}

