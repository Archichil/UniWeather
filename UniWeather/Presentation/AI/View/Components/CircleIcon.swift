//
//  CircleIcon.swift
//  UniWeather
//
//  Created by Daniil on 27.03.25.
//

import SwiftUI

struct CircleIcon: View {
    var icon: String
    
    var body: some View {
        Circle()
            .fill(Color(red: 52 / 255, green: 54 / 255, blue: 58 / 255))
            .frame(width: 50, height: 50)
            .overlay(
                Image(systemName: icon)
                    .foregroundColor(Color(red: 180 / 255, green: 181 / 255, blue: 188 / 255))
                    .font(.title2)
            )
    }
}
