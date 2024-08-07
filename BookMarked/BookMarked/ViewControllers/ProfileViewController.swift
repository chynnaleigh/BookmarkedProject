//
//  ProfileViewController.swift
//  BookMarked
//
//  Created by Chynna Leigh Alcaide on 2024-07-23.
//

import Foundation
import SwiftUI

struct ProfileViewController: View {
    var isSelected: Bool
    
    var body: some View {
        VStack {
            if isSelected {
                Rectangle()
                    .fill(Color(hex: "#64B1FE"))
                    .frame(height: 1)
            }
        }
    }
}
