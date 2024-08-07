//
//  BookViewController.swift
//  BookMarked
//
//  Created by Chynna Leigh Alcaide on 2024-07-23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct BookViewController: View {
    @StateObject private var viewModel = BookViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel
    private let firestoreService = FirestoreService()
    
    @State private var unreadThumbnails: [String?] = []
    @State private var showAllBooks = false
    
    var isSelected: Bool
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack {
                    VStack {
                        HStack {
                            Spacer()
                            
                            Text("My Books")
                            
                            Spacer()
                        }
                        
                        Spacer()
                    }
                    .background(Color(hex: "#FF9900")) // Background color for the entire width
                    .frame(maxHeight: 60)
                }
                
                VStack {
                    Text("READING")
                    ScrollView(.horizontal) {
                        HStack(spacing: 15) {
                            ForEach(0..<10) { _ in
                                ReadingCard1()
                            }
                        }
                    }
                    
                    HStack {
                        Text("Unread")
                        Spacer()
                        NavigationLink(destination: AllBooksViewController(collectionName: "Unread").environmentObject(authViewModel), isActive: $showAllBooks) {
                            Button(action: {
                                showAllBooks = true
                            }) {
                                Text("see all")
                            }
                        }
                    }
                    HStack {
                        ForEach(unreadThumbnails, id: \.self) { thumbnail in
                            if let url = URL(string: thumbnail ?? "") {
                                AsyncImage(url: url) { image in
                                    image.resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 100, height: 150)
                                        .clipped()
                                        .cornerRadius(8)
                                } placeholder: {
                                    Rectangle()
                                        .fill(Color.gray.opacity(0.3))
                                        .frame(width: 100, height: 150)
                                        .cornerRadius(8)
                                }
                            } else {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: 100, height: 150)
                                    .cornerRadius(8)
                            }
                        }
                    }.onAppear {
                        if authViewModel.isAuthenticated, let userID = authViewModel.user?.uid {
                            firestoreService.getFirstThreeThumbnails(userID: userID, bookCollectionName: "Unread") { thumbnails in
                                unreadThumbnails = thumbnails
                            }
                        }
                    }
                    Spacer()
                }
                .padding()
            }
            
        }.navigationBarBackButtonHidden(true)
    }
}



struct ReadingCard1: View {
    var body: some View {
        HStack {
            HStack {
                Image("book")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                    .frame(width: 88)
                    .padding(.vertical)
                
                Spacer()
                
                VStack(alignment: .leading) {
                    Text("Harry Potter and the philosopher's stone")
                        .lineLimit(1)
                    Text("By: J.K. Rowling")
                        .lineLimit(1)
                    
                    // update progress button
                    
                    HStack {
                        Text("PROGRESS:")
                        Spacer()
                        Text("50%")
                    }
                    
                    // progress bar
                    
                }.padding()
            }.padding(.horizontal)
        }
        .background(Color(hex: "#EEEEEE"))
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .frame(width: 343, height: 215)
    }
}



struct BookViewController_Preview: PreviewProvider {
    static var previews: some View {
        BookViewController(isSelected: true)
            .environmentObject(AuthViewModel())
    }
}
