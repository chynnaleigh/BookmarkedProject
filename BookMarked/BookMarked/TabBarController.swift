//
//  TabBarController.swift
//  BookMarked
//
//  Created by Chynna Leigh Alcaide on 2024-07-29.
//

import SwiftUI

class TabBarController: ObservableObject {
    @Published var selectedTab: Int = 0 {
        didSet {
            // Notify about tab re-selection
            if oldValue == selectedTab {
                NotificationCenter.default.post(name: .reselectHomeTab, object: nil)
            }
        }
    }
}

extension Notification.Name {
    static let reselectHomeTab = Notification.Name("reselectHomeTab")
}
