//
//  EditBookViewController.swift
//  BookMarked
//
//  Created by Chynna Leigh Alcaide on 2024-08-08.
//

import SwiftUI
import FirebaseFirestore

struct EditBookViewController: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    private let firestoreService = FirestoreService()
    
    @State var selectedStatus: String
    @State var currentPage: Int
    @State var totalPageCount: Int
    
    @State var book: BookAllData
    var collectionName: String
    
    var body: some View {
        NavigationView {
                    VStack {
                        Form {
                            Section(header: Text("Status")) {
                                Picker("Select Status", selection: $selectedStatus) {
                                    Text("Unread").tag("Unread")
                                    Text("Reading").tag("Reading")
                                    Text("Completed").tag("Completed")
                                }
                                .pickerStyle(SegmentedPickerStyle())
                            }
                            
                            Section(header: Text("Progress")) {
                                HStack {
                                    Text("Current Page")
                                    Spacer()
                                    TextField("Current Page", value: $currentPage, formatter: NumberFormatter())
                                        .keyboardType(.numberPad)
                                        .multilineTextAlignment(.trailing)
                                        .frame(width: 100)
                                }
                                
                                HStack {
                                    Text("Total Page Count")
                                    Spacer()
                                    TextField("Total Page Count", value: $totalPageCount, formatter: NumberFormatter())
                                        .keyboardType(.numberPad)
                                        .multilineTextAlignment(.trailing)
                                        .frame(width: 100)
                                }
                            }
                        }
                        
                        Button(action: saveChanges) {
                            Text("Save")
                                .font(.headline)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .padding()
                    }
                    .navigationTitle("Edit Book")
                }
    }
    
    private func saveChanges() {
        guard let userID = authViewModel.user?.uid else { return }
        
        // Remove the book from the old collection if the status has changed
        if collectionName != selectedStatus {
            firestoreService.removeBookFromCollection(userID: userID, collectionName: collectionName, bookID: book.id) { success in
                if success {
                    // Update the book with the new status and save it to the new collection
                    var updatedBook = book
                    updatedBook.lastEdited = Date()
                    updatedBook.pageCount = totalPageCount
                    firestoreService.addBookToCollection(userID: userID, book: updatedBook, collectionName: selectedStatus) { success in
//                        if success {
//                            presentationMode.wrappedValue.dismiss()
//                        }
                    }
                }
            }
        } else {
            var updatedBook = book
            updatedBook.lastEdited = Date()
            updatedBook.pageCount = totalPageCount
                
            firestoreService.addBookToCollection(userID: userID, book: updatedBook, collectionName: selectedStatus) { success in
                print("Added book to collection")
            }
        }
    }
}

