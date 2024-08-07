////
////  BookModel.swift
////  BookMarked
////
////  Created by Chynna Leigh Alcaide on 2024-07-16.
////

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct ContentView: View {
    @StateObject private var viewModel = BookViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel
    private let firestoreService = FirestoreService()
    
    @State private var showAlert = false
    @State private var alertMessage: String = ""
    
    var searchQuery: String
    
    var body: some View {
        NavigationView {
            List(viewModel.books) { book in
                HStack {
                    if let url = URL(string: book.thumbnail ?? "") {
                        AsyncImage(url: url) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }.frame(width: 50, height: 75).cornerRadius(5)
                    }
                    
                    VStack(alignment: .leading) {
                        Text(book.title)
                        
                        Text(book.authors.joined(separator: ", "))
                    }
                    
                    Spacer()
                    
                    Image("addButtonBlack").resizable()
                        .aspectRatio(contentMode: .fit)
                        .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                        .frame(width: 14)
                        .onTapGesture {
                            if authViewModel.isAuthenticated {
                                if let userID = authViewModel.user?.uid {
                                    firestoreService.addBookToUnread(userID: userID, book: book) { success in
                                            if success {
                                                alertMessage = "Book has been added to Unread"
                                            } else {
                                                alertMessage = "Failed to add book. Please try again."
                                            }
                                            showAlert = true
                                        }
                                    } else {
                                        alertMessage = "User is not logged in"
                                        showAlert = true
                                    }
                            }
                        }
                }
            }
            .navigationTitle("Results")
            .onAppear {
                viewModel.fetchBooks(query: searchQuery)
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Notification"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(searchQuery: "Harry Potter")
            .environmentObject(AuthViewModel())
    }
}
