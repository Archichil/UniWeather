//
//  AIView.swift
//  UniWeather
//
//  Created by Daniil on 26.03.25.
//

import SwiftUI

struct AIView: View {
    @StateObject private var viewModel = AIViewModel()
    @State private var showDaySheet = false
    @State private var showAnswerSheet = false
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
                    ForEach(AvailablePrompts.allCases, id: \.self) { prompt in
                        AIPromptItem(
                            size: 180,
                            text: prompt.rawValue,
                            icon: prompt.iconName
                        )
                        .onTapGesture {
                            showDaySheet = true
                            viewModel.handleItemClick(prompt)
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
        .sheet(isPresented: $showDaySheet) {
            DaySelectionView(
                showDaySheet: $showDaySheet,
                showAnswerSheet: $showAnswerSheet,
                viewModel: viewModel
            )
                .presentationDetents([.fraction(0.3), .fraction(0.31)])
                .presentationBackground(Color(red: 28 / 255, green: 30 / 255, blue: 31 / 255))
        }
        .sheet(isPresented: $showAnswerSheet) {
            PromptDetailView(viewModel: viewModel)
                .presentationDetents([.fraction(1), .fraction(1.1)])
                .presentationBackground(Color(red: 28 / 255, green: 30 / 255, blue: 31 / 255))
        }
        .background(backgroundGradient)
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
