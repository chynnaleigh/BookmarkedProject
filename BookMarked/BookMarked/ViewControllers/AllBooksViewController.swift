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
                            }
                        }
                        .padding(.horizontal)
                    }
                    .onAppear {
                        if authViewModel.isAuthenticated, let userID = authViewModel.user?.uid { firestoreService.getAllBooksInCollection(userID: userID, bookCollectionName: collectionName) { fetchedBooks in
                                books = fetchedBooks
                                print("Fetched books: \(books)")
                                for book in books {
                                    print("Thumbnail URL: \(book.thumbnail ?? "No URL")")
                                }
                            }
                        }
                    }
                }
//            }.navigationBarBackButtonHidden(true)
        }
}
