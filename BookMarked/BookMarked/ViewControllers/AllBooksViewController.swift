//
//  AllBooksViewController.swift
//  BookMarked
//
//  Created by Chynna Leigh Alcaide on 2024-07-30.
//

import SwiftUI
import FirebaseFirestore

struct AllBooksViewController: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    private let firestoreService = FirestoreService()
    
    @State private var books: [BookAllData] = []
    @State private var selectedBook: BookAllData?
    @State private var showingBookDetail = false
        
    var collectionName: String
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
        
        var body: some View {
//            NavigationStack {
                VStack {
                    Text(collectionName)
                        .font(.largeTitle)
                        .padding()
                    
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(books, id: \.id) { book in
                                VStack {
                                    if let urlString = book.thumbnail, let url = URL(string: urlString) {
                                        AsyncImage(url: url) { image in
                                            image.resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 100, height: 150)
                                        } placeholder: {
                                            Rectangle()
                                                .fill(Color.gray.opacity(0.3))
                                                .frame(width: 100, height: 150)
                                        }
                                    } else {
                                        Rectangle()
                                            .fill(Color.gray.opacity(0.3))
                                            .frame(width: 100, height: 150)
                                    }
                                    
                                    Text(book.title)
                                        .font(.headline)
                                        .lineLimit(1)
                                        .frame(maxWidth: 100)
                                    Spacer()
                                }
                                .padding()
                                .onTapGesture {
                                    selectedBook = book
                                    showingBookDetail = true
                                }
                            }
                            .padding(.horizontal)
                        }
                        .onAppear {
                            fetchBooks()
                            }
                        }
                    .navigationDestination(isPresented: $showingBookDetail) {
                        if let selectedBook = selectedBook {
                            if collectionName == "All" {
                                // Determine collection asynchronously
                                BookDetailsViewController(book: selectedBook, currentCollectionName: "Loading...")
                                    .environmentObject(authViewModel)
                                    .onAppear {
                                        firestoreService.determineCollection(for: selectedBook, userID: authViewModel.user?.uid ?? "") { determinedCollection in
                                            if let collection = determinedCollection {
                                                BookDetailsViewController(book: selectedBook, currentCollectionName: collection)
                                                    .environmentObject(authViewModel)
                                            }
                                    }
                                }
                            } else {
                                BookDetailsViewController(book: selectedBook, currentCollectionName: collectionName)
                                    .environmentObject(authViewModel)
                            }
                        } else {
                            // Handle the case where `selectedBook` is nil
                            Text("Error: No book selected")
                        }
                    }
                }
            }
//            }.navigationBarBackButtonHidden(true)
    private func fetchBooks() {
        if authViewModel.isAuthenticated, let userID = authViewModel.user?.uid {
            if collectionName == "All" {
                firestoreService.getAllBooks(userID: userID) { fetchedBooks in
                    books = fetchedBooks
                }
            } else {
                firestoreService.getAllBooksFromSubcollection(userID: userID, subcollectionName: collectionName) { fetchedBooks in
                    books = fetchedBooks
                }
            }
        }
    }
}
