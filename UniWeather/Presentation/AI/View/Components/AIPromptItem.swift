//
//  AIPromptItem.swift
//  UniWeather
//
//  Created by Daniil on 26.03.25.
//

import SwiftUI

struct AIPromptItem: View {
    var size: CGFloat
    var text: String
    var icon: String

    let promptGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color(hex: "#3A3A5A"),
            Color(hex: "#2A2A4A"),
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    let lightText = Color.white.opacity(0.9)

    var body: some View {
        VStack(alignment: .leading) {
            AICircleIcon(
                icon: icon,
                size: 50,
                bgColor: Color(red: 30 / 255, green: 32 / 255, blue: 36 / 255),
                iconColor: Color(red: 101 / 255, green: 87 / 255, blue: 255 / 255),
                font: .title2
            )

            Text(text)
                .font(.subheadline)
                .foregroundStyle(lightText)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
        }
        .padding()
        .frame(width: size, height: size)
        .background(promptGradient)
        .background(Color(red: 30 / 255, green: 32 / 255, blue: 36 / 255))
        .cornerRadius(10)
    }
}
