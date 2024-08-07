//
//  TabViewContainer.swift
//  BookMarked
//
//  Created by Chynna Leigh Alcaide on 2024-07-23.
//

import SwiftUI

struct TabViewContainer: View {
//    @State private var selectedTab = 0
    @StateObject private var tabBarController = TabBarController()
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some View {
        TabView(selection: $tabBarController.selectedTab) {
            SearchViewContainer(isSelected: tabBarController.selectedTab == 0).tabItem {
                CustomTabBarItem(
                    iconName: tabBarController.selectedTab == 0 ? "homeIconSelected" : "homeIcon",
                    label: "Home",
                    isSelected: tabBarController.selectedTab == 0,
                    iconSize: 35)
            }.tag(0)
            
            BookViewController(isSelected: tabBarController.selectedTab == 1).tabItem {
                CustomTabBarItem(
                    iconName: tabBarController.selectedTab == 1 ? "bookIconSelected" : "bookIcon",
                    label: "My Books",
                    isSelected: tabBarController.selectedTab == 1,
                    iconSize: 40)
            }.tag(1)
                .environmentObject(authViewModel)
            
            EditProfileViewController(isSelected: tabBarController.selectedTab == 2).tabItem {
                CustomTabBarItem(
                    iconName: tabBarController.selectedTab == 2 ? "profileIconSelected" : "profileIcon",
                    label: "Profile",
                    isSelected: tabBarController.selectedTab == 2,
                    iconSize: 35)
            }.tag(2)
        }
        .environmentObject(tabBarController)
        .background(Color(hex: "#F6F6F6"))
    }
}

struct TabViewContainer_Previews: PreviewProvider {
    static var previews: some View {
        TabViewContainer()
    }
}

