//
//  ViewController.swift
//  BookMarked
//
//  Created by Chynna Leigh Alcaide on 2024-07-23.
//

import Foundation
import SwiftUI

struct ViewController: View {
    
    var body: some View {
        TabView {
            Text("Home View").tabItem {
                Image("homeIcon")
                Text("Home").padding(.top, 5)
            }
            
            Text("Book View").tabItem { Image("bookIcon")
                Text("My Books")
            }
            
            Text("Profile View").tabItem { Image("profileIcon")
                Text("Profile")
            }
        }
    }
}

struct ViewController_Previews: PreviewProvider {
    static var previews: some View {
        ViewController()
    }
}
