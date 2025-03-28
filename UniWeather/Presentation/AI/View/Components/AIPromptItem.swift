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
    
    var body: some View {
        VStack(alignment: .leading) {
            
            AICircleIcon(
                icon: icon,
                size: 50,
                bgColor: Color(red: 52 / 255, green: 54 / 255, blue: 58 / 255),
                iconColor: Color(red: 180 / 255, green: 181 / 255, blue: 188 / 255),
                font: .title2
            )
            
            Text(text)
                .font(.subheadline)
                .foregroundStyle(Color(red: 180 / 255, green: 181 / 255, blue: 188 / 255))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
            
        }
        .padding()
        .frame(width: size, height: size)
        .background(Color(red: 29 / 255, green: 31 / 255, blue: 32 / 255))
        .cornerRadius(10)
    }
}

#Preview {
    AIView()
}
