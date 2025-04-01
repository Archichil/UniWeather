//
//  AIView.swift
//  UniWeather
//
//  Created by Daniil on 26.03.25.
//

import SwiftUI

struct AIView: View {
    // MARK: - Constants
    private enum Constants {
        enum Colors {
            static let darkBackground = Color(red: 28/255, green: 30/255, blue: 31/255)
            static let circleIconBackground = Color(red: 29/255, green: 31/255, blue: 32/255)
            static let circleIcon = Color(red: 180/255, green: 181/255, blue: 188/255)
            
            static let backgroundGradient = LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 71/255, green: 70/255, blue: 66/255),
                    Color(red: 50/255, green: 52/255, blue: 53/255)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            
            static let titleGradient = LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: Color(red: 255/255, green: 251/255, blue: 255/255), location: 0.3),
                    .init(color: Color(red: 167/255, green: 169/255, blue: 173/255), location: 0.7),
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
        }
        
        enum Layout {
            static let columnsSpacing: CGFloat = 15
            static let promptItemSize: CGFloat = 180
            static let circleIconSize: CGFloat = 65
            static let verticalPadding: CGFloat = 10
            static let horizontalPadding: CGFloat = 20
            static let bottomPadding: CGFloat = 15
            static let titleFontSize: CGFloat = 45
        }
        
        enum Text {
            static let greeting = "Hello,\nhow can I help\nyou today?"
            static let chatIcon = "bubble.left.and.text.bubble.right"
        }
        
        enum Sheets {
            static let datePickerDetents: Set<PresentationDetent> = [.fraction(0.35)]
            static let chatViewDetents: Set<PresentationDetent> = [.fraction(0.9), .fraction(0.91)]
        }
    }
    
    // MARK: - Properties
    @StateObject private var viewModel = AIViewModel()
    @State private var showDaySheet = false
    @State private var showAnswerSheet = false
    
    // MARK: - Main View
    var body: some View {
        ZStack(alignment: .bottom) {
            Constants.Colors.backgroundGradient
                .edgesIgnoringSafeArea(.all)
            
            mainContent
            chatButton
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .sheet(isPresented: $showDaySheet) {
            datePickerSheet
        }
        .sheet(isPresented: $showAnswerSheet) {
            chatViewSheet
        }
    }
    
    // MARK: - Subviews
    private var mainContent: some View {
        ScrollView {
            VStack(alignment: .leading) {
                greetingText
                promptsGrid
            }
            .padding(.top)
        }
        .padding(.horizontal, Constants.Layout.horizontalPadding)
        .scrollIndicators(.hidden)
    }
    
    private var greetingText: some View {
        Text(Constants.Text.greeting)
            .font(.system(size: Constants.Layout.titleFontSize))
            .fontWeight(.medium)
            .foregroundStyle(Constants.Colors.titleGradient)
    }
    
    private var promptsGrid: some View {
        VStack(spacing: Constants.Layout.columnsSpacing) {
            ForEach(groupedPrompts.indices, id: \.self) { rowIndex in
                HStack(spacing: Constants.Layout.columnsSpacing) {
                    ForEach(groupedPrompts[rowIndex], id: \.self) { prompt in
                        AIPromptItem(
                            size: 180,
                            text: prompt.rawValue,
                            icon: prompt.iconName
                        )
                        .onTapGesture {
                            handlePromptSelection(prompt)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
        }
        .padding(.top)
    }
    
    private var groupedPrompts: [[AvailablePrompts]] {
        AvailablePrompts.allCases.chunked(into: 2)
    }
    
    private var chatButton: some View {
        AICircleIcon(
            icon: Constants.Text.chatIcon,
            size: Constants.Layout.circleIconSize,
            bgColor: Constants.Colors.circleIconBackground,
            iconColor: Constants.Colors.circleIcon,
            font: .title
        )
        .padding(.trailing, Constants.Layout.horizontalPadding)
        .padding(.bottom, Constants.Layout.bottomPadding)
        .onTapGesture {
            showAnswerSheet = true
        }
    }
    
    private var datePickerSheet: some View {
        AIDatePickerView(
            showDaySheet: $showDaySheet,
            showAnswerSheet: $showAnswerSheet,
            viewModel: viewModel
        )
        .presentationDetents(Constants.Sheets.datePickerDetents)
        .presentationDragIndicator(.visible)
        .presentationBackground(Constants.Colors.darkBackground)
    }
    
    private var chatViewSheet: some View {
        AIChatView(viewModel: viewModel)
            .presentationDetents(Constants.Sheets.chatViewDetents)
            .presentationBackground(Constants.Colors.darkBackground)
    }
    
    // MARK: - Private methods
    private func handlePromptSelection(_ prompt: AvailablePrompts) {
        if !viewModel.isFetching {
            viewModel.selectedPrompt = prompt
            showDaySheet = true
        }
    }
}

// MARK: - Preview
#Preview {
    AIView()
}
