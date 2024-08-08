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
            "description": book.description ?? "",
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
    
    func getFirstThreeThumbnailsForAll(userID: String, completion: @escaping ([String]) -> Void) {
        let userDoc = db.collection("users").document(userID)
        
        let subcollections = ["Unread", "Reading", "Completed"]
        
        var thumbnails: Set<String> = []
        let dispatchGroup = DispatchGroup()
        
        func fetchBooks(from collectionName: String) {
            dispatchGroup.enter()
            let bookCollection = userDoc.collection("Books").document(collectionName).collection(collectionName)
            
            bookCollection.order(by: "dateAdded", descending: false).limit(to: 3).getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting books: \(error)")
                    dispatchGroup.leave()
                    return
                }
                
                for document in querySnapshot?.documents ?? [] {
                    if let thumbnail = document.data()["thumbnail"] as? String {
                        thumbnails.insert(thumbnail)
                    }
                }
                
                dispatchGroup.leave()
            }
        }
        
        for subcollection in subcollections {
            fetchBooks(from: subcollection)
        }
        
        dispatchGroup.notify(queue: .main) {
            let limitedThumbnails = Array(thumbnails).prefix(3)
            completion(Array(limitedThumbnails))
        }
    }
    
    func getAllBooks(userID: String, completion: @escaping ([BookAllData]) -> Void) {
        let userDoc = db.collection("users").document(userID)
        let subcollections = ["Unread", "Reading", "Completed"]

        var allBooks: [BookAllData] = []
        let dispatchGroup = DispatchGroup()

        for subcollection in subcollections {
            dispatchGroup.enter()
            let bookCollection = userDoc.collection("Books").document(subcollection).collection(subcollection)

            bookCollection.order(by: "dateAdded", descending: false).getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting books from \(subcollection): \(error)")
                    dispatchGroup.leave()
                    return
                }

                for document in querySnapshot?.documents ?? [] {
                    if let title = document.data()["title"] as? String {
                        let id = UUID(uuidString: document.documentID) ?? UUID()
                        let thumbnail = document.data()["thumbnail"] as? String
                        let book = BookAllData(id: id, title: title, thumbnail: thumbnail)
                        allBooks.append(book)
                    }
                }
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) {
            completion(allBooks)
        }
    }

        
    func getAllBooksFromSubcollection(userID: String, subcollectionName: String, completion: @escaping ([BookAllData]) -> Void) {
        let userDoc = db.collection("users").document(userID)
        let bookCollection = userDoc.collection("Books").document(subcollectionName).collection(subcollectionName)
        
        bookCollection.order(by: "dateAdded", descending: false).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                completion([])
                return
            }
            
            var books: [BookAllData] = []
            for document in querySnapshot?.documents ?? [] {
                if let title = document.data()["title"] as? String {
                    let id = UUID(uuidString: document.documentID) ?? UUID()
                    let thumbnail = document.data()["thumbnail"] as? String
                    let book = BookAllData(
                        id: id,
                        title: title,
                        thumbnail: thumbnail
                    )
                    books.append(book)
                }
            }
            completion(books)
        }
    }
    
    func removeBookFromCollection(userID: String, collectionName: String, bookID: UUID, completion: @escaping (Bool) -> Void) {
        let userDoc = db.collection("users").document(userID)
        let bookCollection = userDoc.collection("Books").document(collectionName).collection(collectionName)
        
        bookCollection.document(bookID.uuidString).delete { error in
            if let error = error {
                print("Error removing book from Firestore: \(error)")
                completion(false)
            } else {
                print("Book \(bookID) successfully removed from Firestore collection \(bookCollection)")
                completion(true)
            }
        }
    }
    
    
    func addBookToCollection(userID: String, book: BookAllData, collectionName: String, completion: @escaping (Bool) -> Void) {
        let userDoc = db.collection("users").document(userID)
        let bookCollection = userDoc.collection("Books").document(collectionName).collection(collectionName)
        
        let bookDoc = bookCollection.document(book.id.uuidString)
        
        let dateAdded = Timestamp(date: book.dateAdded ?? Date())
        let lastEdited = Timestamp(date: book.lastEdited ?? Date())
        
        let bookData: [String: Any] = [
            "title": book.title,
            "authors": book.authors ?? [],
            "description": book.description ?? "",
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
}

