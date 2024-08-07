//
//  HomeViewController.swift
//  BookMarked
//
//  Created by Chynna Leigh Alcaide on 2024-07-16.
//

import Foundation
import SwiftUI

struct HomeViewController: View {
    @State private var searchQuery: String = ""
    
    var isSelected: Bool
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack(alignment: .leading) {
                    Spacer().frame(maxHeight: 25)
                    
                    HStack {
                        Spacer()
                        
                        Image("logo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                            .frame(width: 77)
                        
                        Spacer()
                        
                        VStack(alignment: .leading) {
                            Text("Hi User,")
                            Text("You've read 2 books this month").fixedSize(horizontal: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                            Text("Let's keep the adventure going!")
                                .fixedSize(horizontal: true, vertical: true)
                        }.padding()
                        
                        Spacer()
                    }
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.black, lineWidth: 2) // Border with rounded corners
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                    .frame(width: .infinity, height: 90)
                    
                    Spacer().frame(maxHeight: 25)
                    
                    Text("Your Currently Reading...")
                    ScrollView(.horizontal) {
                        HStack(spacing: 15) {
                            ForEach(0..<10) { _ in
                                ReadingCard()
                            }
                        }
                    }
                    
                    Text("Your Recent Books")
                    Rectangle()
                        .fill(Color(hex: "#64B1FE"))
                        .frame(width: 128, height: 1)
                    RecentList()
                    
                    Spacer()
                }
                .padding(.horizontal, 10)
                .frame(width: .infinity, height: .infinity)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

private func safeAreaTop() -> CGFloat {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        return window?.safeAreaInsets.top ?? 0
}

struct ReadingCard: View {
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

struct RecentList: View {
    @StateObject private var viewModel = BookViewModel()
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(viewModel.books) { book in
                    HStack(spacing: 10) {
                        RecentBookStack(book: book)
                    }.padding()
                }
            }
            .background(Color(hex: "#EEEEEE"))
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .onAppear {
                viewModel.fetchBooks(query: "Lord of the Rings")
            }
        }
    }
}

struct RecentBookStack: View {
    var book: Book
    
    var body: some View {
        VStack {
//            Image("book")
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
//                .frame(width: 88)
            if let url = URL(string: book.thumbnail ?? "") {
                AsyncImage(url: url) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }.frame(width: 50, height: 75).cornerRadius(5)
            }
            
            Text(book.title)
                .font(.system(size: 10.5))
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .frame(height: 26)
        }
    }
}

struct HomeViewController_Previews: PreviewProvider {
    static var previews: some View {
        HomeViewController(isSelected: true)
    }
}
