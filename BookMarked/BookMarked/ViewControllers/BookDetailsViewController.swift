//
//  BookDetailsViewController.swift
//  BookMarked
//
//  Created by Chynna Leigh Alcaide on 2024-08-08.
//

import SwiftUI
import FirebaseFirestore

struct BookDetailsViewController: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    private let firestoreService = FirestoreService()
    
    var book: BookAllData
    var currentCollectionName: String
    
    @State private var selectedStatus: String = ""
    
    var body: some View {
        VStack {
            if let urlString = book.thumbnail, let url = URL(string: urlString) {
                AsyncImage(url: url) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200, height: 300)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 200, height: 300)
            }
        }
            
        Text(book.title)
            .font(.largeTitle)
            .padding()
            
        if let authors = book.authors {
            Text("Authors: \(authors.joined(separator: ", "))")                    .font(.title2)
        }
            
        if let description = book.description {
            Text(description)
                .padding()
        }
            
        Picker("Status", selection: $selectedStatus) {
            Text("Unread").tag("Unread")
            Text("Reading").tag("Reading")
            Text("Completed").tag("Completed")
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding()
        
        Button(action: updateBookStatus) {
            Text("Update Status")
                .font(.headline)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
        .padding()
    }
    .navigationTitle("Book Details")
    .onAppear {
        // Set the initial status based on the current collection
        selectedStatus = currentCollectionName // Assume bookCollectionName is available
    }
}

    private func updateBookStatus() {
        guard let userID = authViewModel.user?.uid else { return }
        
        let oldCollectionName = currentCollectionName
        let newCollectionName = selectedStatus
        
        // Remove book from the old collection
        firestoreService.removeBookFromCollection(userID: userID, collectionName: oldCollectionName, bookID: book.id) { success in
            if success {
                // Add book to the new collection with updated lastEdited date
                var updatedBook = book
                updatedBook.lastEdited = Date()
                
                firestoreService.addBookToCollection(userID: userID, book: updatedBook, collectionName: newCollectionName) { success in
                    if success {
                        print("Book status updated successfully")
                    }
                }
            }
        }
    }
}

