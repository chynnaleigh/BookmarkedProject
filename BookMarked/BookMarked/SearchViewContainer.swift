//
//  SearchViewContainer.swift
//  BookMarked
//
//  Created by Chynna Leigh Alcaide on 2024-07-29.
//

import SwiftUI

struct SearchViewContainer: View {
    @State private var searchQuery: String = ""
    @State private var isNavigating: Bool = false
    @State private var isSearchResultsView = false
    
    @StateObject private var authViewModel = AuthViewModel()
    
    var isSelected: Bool
    @EnvironmentObject var tabBarController: TabBarController
    
    var body: some View {
        VStack {
            VStack {
                NavigationStack {
                    VStack {
                        VStack {
                            SearchBar(text: $searchQuery, isNavigating: $isNavigating, isSearchResultsView: $isSearchResultsView)
                        }
                        .background(Color(hex: "#FF9900"))
                        
                        Spacer()
                    }
                    .navigationDestination(isPresented: $isNavigating) {
                        ContentView(searchQuery: searchQuery)
                            .onDisappear {
                                resetSearch()
                            }
                    }
                }.navigationBarBackButtonHidden(true)
                .frame(height: 60)
            }
            if self.isSearchResultsView {
                ContentView(searchQuery: searchQuery)
                    .environmentObject(authViewModel)
            } else {
                HomeViewController(isSelected: true)
            }
            Spacer()
        }
        .onChange(of: isSelected) { newValue in
            if !newValue {
                // reset state when switching tabs
                resetSearch()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .reselectHomeTab)) { _ in
            if tabBarController.selectedTab == 0 {
                resetSearch()
            }
        }
    }
    
    private func resetSearch() {
        searchQuery = ""
        isNavigating = false
        isSearchResultsView = false
    }
}

struct SearchBar: View {
    @Binding var text: String
    @Binding var isNavigating: Bool
    @Binding var isSearchResultsView: Bool
    
    var body: some View {
//        HStack {
            TextField("Search", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .cornerRadius(25)
                .padding(.bottom)
                .padding(.horizontal)
                .onSubmit {
                    isNavigating = true
                    isSearchResultsView = true
                }
//        }
    }
}



struct SearchViewContainer_Previews: PreviewProvider {
    static var previews: some View {
        SearchViewContainer(isSelected: true)
    }
}
