//
//  CustomTabBarItem.swift
//  BookMarked
//
//  Created by Chynna Leigh Alcaide on 2024-07-23.
//

import SwiftUI

struct CustomTabBarItem: View {
    let iconName: String
    let label: String
    let isSelected: Bool
    let iconSize: CGFloat
    
    var body: some View {
        VStack(spacing: 2) {
            if isSelected {
                Rectangle()
                    .fill(Color(hex: "#64B1FE"))
                    .frame(width: iconSize, height: 2)
                    .padding(.bottom, 4)
            }
            
            Image(iconName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: iconSize, height: iconSize)
            
            Text(label)
                .font(.caption)
                .foregroundColor(isSelected ? .black : .gray)
        }
    }
}
