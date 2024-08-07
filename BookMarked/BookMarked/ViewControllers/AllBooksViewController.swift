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
    
    @State private var books: [Book] = []
        
        var collectionName: String
        
        var body: some View {
//            NavigationStack {
                VStack {
                    Text(collectionName)
                        .font(.largeTitle)
                        .padding()
                    
                    ScrollView {
                        LazyVStack {
                            ForEach(books) { book in
                                HStack {
                                    if let url = URL(string: book.thumbnail ?? "") {
                                        AsyncImage(url: url) { image in
                                            image.resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 100, height: 150)
                                                .cornerRadius(8)
                                        } placeholder: {
                                            Rectangle()
                                                .fill(Color.gray.opacity(0.3))
                                                .frame(width: 100, height: 150)
                                                .cornerRadius(8)
                                        }
                                    }
                                    
                                    VStack(alignment: .leading) {
                                        Text(book.title)
                                            .font(.headline)
                                        Text((book.authors.joined(separator: ", ")) ?? "Unknown Author")
                                            .font(.subheadline)
                                    }
                                    Spacer()
                                }
                                .padding()
                            }
                        }
                    }
                    .onAppear {
                        if authViewModel.isAuthenticated, let userID = authViewModel.user?.uid {
                            firestoreService.getAllBooksInCollection(userID: userID, bookCollectionName: collectionName) { fetchedBooks in
                                books = fetchedBooks
                            }
                        }
                    }
                }
//            }.navigationBarBackButtonHidden(true)
        }
}
