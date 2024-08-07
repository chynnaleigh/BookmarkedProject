//
//  FirestoreService.swift
//  BookMarked
//
//  Created by Chynna Leigh Alcaide on 2024-07-30.
//

import FirebaseFirestore

class FirestoreService {
    private let db = Firestore.firestore()
    
    func addBookToUnread(userID: String, book: Book, completion: @escaping (Bool) -> Void) {
        let userDoc = db.collection("users").document(userID)
        let unreadCollection = userDoc.collection("Books").document("Unread").collection("Unread")
        
        let bookDoc = unreadCollection.document()
        
        let dateAdded = Timestamp(date: book.dateAdded)
        let lastEdited = Timestamp(date: book.lastEdited)
        
        let bookData: [String: Any] = [
            "title": book.title,
            "authors": book.authors,
            "thumbnail": book.thumbnail ?? "",
            "pageCount": book.pageCount ?? 0,
            "dateAdded": dateAdded,
            "lastEdited": lastEdited
        ]
        
        bookDoc.setData(bookData) { error in
            if let error = error {
                print("Error adding book to Firestore: \(error)")
                completion(false)
            } else {
                print("Book successfully added to Firestore")
                completion(true)
            }
        }
    }
    
    func getFirstThreeThumbnails(userID: String, bookCollectionName: String, completion: @escaping ([String]) -> Void) {
        let userDoc = db.collection("users").document(userID)
        let bookCollection = userDoc.collection("Books").document(bookCollectionName).collection(bookCollectionName)
        
//        var thumbnails = [String?]()
        
        bookCollection.order(by: "dateAdded", descending: false).limit(to: 3).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting books: \(error)")
                completion([])
            }
            var thumbnails: [String] = []
            for document in querySnapshot?.documents ?? [] {
                if let thumbnail = document.data()["thumbnail"] as? String {
                    thumbnails.append(thumbnail)
                }
            }
            
            completion(thumbnails)
        }
    }
    
    func getAllBooksInCollection(userID: String, bookCollectionName: String, completion: @escaping([Book]) -> Void) {
        let userDoc = db.collection("users").document(userID)
        let bookCollection = userDoc.collection("Books").document(bookCollectionName).collection(bookCollectionName)
        
        bookCollection.order(by: "dateAdded", descending: true).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                completion([])
                return
            }
            
            var books: [Book] = []
            for document in querySnapshot?.documents ?? [] {
                if let book = try? document.data(as: Book.self) {
                    books.append(book)
                }
            }
            
            completion(books)
        }
        
    }
}
