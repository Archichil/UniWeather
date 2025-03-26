//
//  AIView.swift
//  UniWeather
//
//  Created by Daniil on 26.03.25.
//

import SwiftUI

struct AIView: View {
    @StateObject private var viewModel = AIViewModel()
    
    private let columns = [
        GridItem(.flexible(), spacing: 15),
        GridItem(.flexible(), spacing: 15)
    ]
    
    var body: some View {
        ZStack(alignment: .bottom) {
            backgroundGradient
                .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                Text("Hello,\nhow can I help\nyou today?")
                    .font(.system(size: 45))
                    .fontWeight(.medium)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(titleGradient)
                
                LazyVGrid(columns: columns, spacing: 15) {
                    ForEach(PromptAction.allCases, id: \.self) { action in
                        AIPromptItem(
                            size: 180,
                            text: action.rawValue,
                            icon: action.iconName
                        )
                        .onTapGesture {
                            viewModel.handleItemClick(action)
                        }
                    }
                }
                .padding(.top)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.vertical, 10)
            .padding(.horizontal)
            .scrollIndicators(.hidden)
        }
    }
    
    private let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color(red: 71 / 255, green: 70 / 255, blue: 66 / 255),
            Color(red: 50 / 255, green: 52 / 255, blue: 53 / 255)
        ]),
        startPoint: .top,
        endPoint: .bottom
    )
    
    private let titleGradient = LinearGradient(
        gradient: Gradient(stops: [
            .init(color: Color(red: 255 / 255, green: 251 / 255, blue: 255 / 255), location: 0.3),
            .init(color: Color(red: 167 / 255, green: 169 / 255, blue: 173 / 255), location: 0.7),
        ]),
        startPoint: .top,
        endPoint: .bottom
    )
}

#Preview {
    AIView()
}
