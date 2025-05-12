//
//  AIChatDropUpMenu.swift
//  UniWeather
//
//  Created by Daniil on 27.03.25.
//

import SwiftUI

struct AIChatDropUpMenu: View {
    // MARK: - Constants

    private enum Constants {
        enum Colors {
            static let background = Color(hex: "#070728")
            static let dropdownBackground = Color(hex: "#050524")
            static let text = Color.white
            static let disabledText = Color.gray
        }

        enum Layout {
            static let spacing: CGFloat = 0
            static let buttonHPadding: CGFloat = 20
            static let buttonVPadding: CGFloat = 15
            static let rowPadding: CGFloat = 10
            static let iconWidth: CGFloat = 20
            static let dropdownHeight: CGFloat = 150
            static let dropdownTopPadding: CGFloat = 10
            static let promptRowHorizontalSpacing: CGFloat = 15
            static let promptRowTextLimit: Int = 1
        }

        enum Animation {
            static let duration: Double = 0.2
        }

        enum Images {
            static let menu = "line.3.horizontal"
        }

        enum Text {
            static let buttonTitle = String(localized: "prompt.buttonTitle")
        }
    }

    // MARK: - Properties

    @ObservedObject var viewModel: AIViewModel
    @Binding var showDropdown: Bool
    var onItemClick: () -> Void

    // MARK: - Main View

    var body: some View {
        VStack(spacing: Constants.Layout.spacing) {
            dropdownContent
            toggleButton
        }
        .frame(maxWidth: .infinity, alignment: .bottom)
    }

    @ViewBuilder
    private var dropdownContent: some View {
        if showDropdown {
            ScrollView {
                scrollContent
                    .padding(.top, Constants.Layout.dropdownTopPadding)
            }
            .frame(maxWidth: .infinity, maxHeight: Constants.Layout.dropdownHeight)
            .background(Constants.Colors.dropdownBackground)
            .zIndex(1)
            .transition(.asymmetric(
                insertion: .move(edge: .bottom).combined(with: .opacity),
                removal: .move(edge: .bottom).combined(with: .opacity)
            )
            .animation(
                .easeInOut(duration: Constants.Animation.duration)
            ))
        }
    }

    private var scrollContent: some View {
        ForEach(AvailablePrompts.allCases, id: \.self) { prompt in
            Button {
                handlePromptSelection(prompt)
            } label: {
                promptRow(prompt)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }

    private func promptRow(_ prompt: AvailablePrompts) -> some View {
        HStack(spacing: Constants.Layout.promptRowHorizontalSpacing) {
            Image(systemName: prompt.iconName)
                .frame(maxWidth: Constants.Layout.iconWidth)
            Text(prompt.title)
                .lineLimit(Constants.Layout.promptRowTextLimit)
        }
        .foregroundStyle(Constants.Colors.text)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Constants.Layout.rowPadding)
        .contentShape(Rectangle())
    }

    private var toggleButton: some View {
        Button {
            withAnimation(.easeInOut(duration: Constants.Animation.duration)) {
                showDropdown.toggle()
            }
        } label: {
            HStack {
                Image(systemName: Constants.Images.menu)
                Text(Constants.Text.buttonTitle)
                    .fontWeight(.medium)
            }
            .foregroundStyle(viewModel.isFetching ? Constants.Colors.disabledText : Constants.Colors.text)
        }
        .disabled(viewModel.isFetching)
        .padding(.horizontal, Constants.Layout.buttonHPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, Constants.Layout.buttonVPadding)
        .background(Constants.Colors.background)
    }

    // MARK: - Handlers

    private func handlePromptSelection(_ prompt: AvailablePrompts) {
        withAnimation {
            viewModel.handleItemClick(prompt)
            showDropdown = false
            onItemClick()
        }
    }
}

// MARK: - Scroll Offset Handling

private struct ViewOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}
