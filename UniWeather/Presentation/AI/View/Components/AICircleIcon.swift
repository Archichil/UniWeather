//
//  AICircleIcon.swift
//  UniWeather
//
//  Created by Daniil on 27.03.25.
//

import SwiftUI

struct AICircleIcon: View {
    var icon: String
    var size: CGFloat
    var bgColor: Color
    var iconColor: Color
    var font: Font
    
    var body: some View {
        Circle()
            .fill(bgColor)
            .frame(width: size, height: size)
            .overlay(
                Image(systemName: icon)
                    .foregroundColor(iconColor)
                    .font(font)
            )
            .overlay(
                Circle()
                    .stroke(iconColor.opacity(0.3), lineWidth: 1)
            )
    }
}
