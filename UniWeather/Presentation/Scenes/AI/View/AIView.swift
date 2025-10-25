//
//  AIView.swift
//  UniWeather
//
//  Created by Daniil on 26.03.25.
//

import SwiftUI
import WeatherService

struct AIView: View {
    // MARK: - Constants

    private enum Constants {
        enum Colors {
            static let darkBackground = Color(red: 18 / 255, green: 20 / 255, blue: 22 / 255)
            static let circleIconBackground = Color(red: 29 / 255, green: 31 / 255, blue: 32 / 255)
            static let circleIcon = Color(red: 180 / 255, green: 181 / 255, blue: 188 / 255)
            static let lightText = Color.white.opacity(0.9)
            static let secondaryText = Color.white.opacity(0.6)
            static let accentColor = Color(red: 101 / 255, green: 87 / 255, blue: 255 / 255)

            static let backgroundGradient = LinearGradient(
                gradient: Gradient(colors: [
                    Color(hex: "#0F0F2D"),
                    Color(hex: "#1A1A3A"),
                ]),
                startPoint: .top,
                endPoint: .bottom
            )

            static let titleGradient = LinearGradient(
                gradient: Gradient(colors: [
                    Color.white,
                    Color(hex: "#B0B0FF"),
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
            static let greeting = String(localized: "aiView.greeting")
            static let chatIcon = "bubble.left.and.text.bubble.right"
            static let navigationTitle = String(localized: "aiView.navigationTitle")
        }

        enum Sheets {
            static let datePickerDetents: Set<PresentationDetent> = [.fraction(0.35)]
            static let chatViewDetents: Set<PresentationDetent> = [.fraction(0.9), .fraction(0.91)]
        }
    }

    // MARK: - Properties

    @StateObject var viewModel: AIViewModel
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
        .navigationTitle(Constants.Text.navigationTitle)
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
                            text: prompt.title,
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
            bgColor: Constants.Colors.accentColor,
            iconColor: Constants.Colors.lightText,
            font: .title
        )
        .padding(.trailing, Constants.Layout.horizontalPadding)
        .padding(.bottom, Constants.Layout.bottomPadding)
        .shadow(color: Constants.Colors.accentColor.opacity(0.5), radius: 10, x: 0, y: 5)
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
        .presentationBackground(Constants.Colors.backgroundGradient)
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
    AIView(viewModel: AIViewModel(coordinates: Coordinates(lat: 53.893009, lon: 27.567444)))
}
