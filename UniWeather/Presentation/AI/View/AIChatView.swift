//
//  AIChatView.swift
//  UniWeather
//
//  Created by Daniil on 26.03.25.
//

import SwiftUI

struct AIChatView: View {
    // MARK: - Constants

    private enum Constants {
        enum Colors {
            static let background = Color(red: 28 / 255, green: 30 / 255, blue: 31 / 255)
            static let bubbleBackground = Color(red: 30 / 255, green: 32 / 255, blue: 36 / 255)
            static let icon = Color(red: 101 / 255, green: 87 / 255, blue: 255 / 255)
            static let text = Color.white
            static let secondaryText = Color.gray
            static let divider = Color.gray.opacity(0.5)
            static let secondaryBackground = Color(hex: "#070728")
            static let backgroundGradient = LinearGradient(
                gradient: Gradient(colors: [
                    Color(hex: "#0F0F2D"),
                    Color(hex: "#1A1A3A"),
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
        }

        enum Layout {
            static let bubbleSize: CGFloat = 50
            static let horizontalPadding: CGFloat = 7
            static let topPadding: CGFloat = 10
            static let vericalSpacing: CGFloat = 0
            static let horizontalSpacing: CGFloat = 10
            static let dividerHeight: CGFloat = 1
            static let textLineLimit: Int = 1
        }

        enum Text {
            static let emptyDialog = String(localized: "chat.emptyDialog")
            static let noPreviousMessage = String(localized: "chat.noPreviousMessage")
            static let lastUpdatedPrefix = String(localized: "chat.lastUpdatedPrefix")
        }

        enum Icons {
            static let chatIcon: String = "bubble.right"
        }
    }

    // MARK: - Properties

    @ObservedObject var viewModel: AIViewModel
    @State private var showDropdown = false
    @State private var scrollProxy: ScrollViewProxy?
    @State private var animatedMessages: [UUID: Bool] = [:]
    @Environment(\.dismiss) var dismiss

    // MARK: - Views

    var body: some View {
        mainChatView
    }

    private var emptyStateView: some View {
        VStack {
            if viewModel.messages.isEmpty {
                VStack {
                    Text(Constants.Text.emptyDialog)
                        .foregroundStyle(Constants.Colors.secondaryText)
                        .multilineTextAlignment(.center)
                        .padding()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .background(Constants.Colors.backgroundGradient)
            }
        }
    }

    private var mainChatView: some View {
        VStack(spacing: Constants.Layout.vericalSpacing) {
            headerView
            dividerView
            if !viewModel.messages.isEmpty {
                messagesListView
            } else {
                emptyStateView
            }
            AIChatDropUpMenu(viewModel: viewModel, showDropdown: $showDropdown, onItemClick: { scrollToBottom() })
        }
    }

    private var headerView: some View {
        HStack(spacing: Constants.Layout.horizontalSpacing) {
            AICircleIcon(
                icon: Constants.Icons.chatIcon,
                size: Constants.Layout.bubbleSize,
                bgColor: Constants.Colors.bubbleBackground,
                iconColor: Constants.Colors.icon,
                font: .title2
            )

            VStack(alignment: .leading) {
                Text(previousMessageText)
                    .foregroundStyle(Constants.Colors.text)
                    .lineLimit(Constants.Layout.textLineLimit)
                    .fontWeight(.medium)

                if !viewModel.messages.isEmpty {
                    Text("\(Constants.Text.lastUpdatedPrefix): \(viewModel.messages.last?.time ?? "")")
                        .foregroundStyle(Constants.Colors.secondaryText)
                        .lineLimit(Constants.Layout.textLineLimit)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            DismissButton(action: dismiss.callAsFunction)
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .padding(.horizontal, Constants.Layout.horizontalPadding)
        .padding(.bottom, Constants.Layout.topPadding)
        .padding(.top)
        .background(Constants.Colors.secondaryBackground)
    }

    private var dividerView: some View {
        Rectangle()
            .frame(maxWidth: .infinity, maxHeight: Constants.Layout.dividerHeight)
            .foregroundStyle(Constants.Colors.divider)
    }

    private var messagesListView: some View {
        ScrollViewReader { proxy in
            ScrollView {
                Rectangle().frame(height: 16).opacity(0)

                ForEach(viewModel.messages.indices, id: \.self) { index in
                    let message = viewModel.messages[index]

                    AIMessageItem(
                        text: message.text,
                        time: message.time,
                        messageId: message.id,
                        isAnswer: message.isAnswer,
                        animationStarted: Binding(
                            get: { animatedMessages[message.id] ?? false },
                            set: { animatedMessages[message.id] = $0 }
                        )
                    )
                    .id(message.id)
                    .padding(message.isAnswer ? .leading : .trailing, Constants.Layout.horizontalPadding)
                    .frame(maxWidth: .infinity, alignment: message.isAnswer ? .leading : .trailing)
                    .padding(.bottom, index == viewModel.messages.count - 1 ? 16 : 0)
                }
            }
            .onAppear {
                scrollProxy = proxy
                scrollToBottom()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Constants.Colors.backgroundGradient)
    }

    // MARK: - Helper Properties

    private var previousMessageText: String {
        viewModel.messages.count > 1 ? viewModel.messages[viewModel.messages.count - 2].text : Constants.Text.noPreviousMessage
    }

    // MARK: - Helper Methods

    private func scrollToBottom() {
        DispatchQueue.main.async {
            if let lastMessage = viewModel.messages.last,
               let proxy = scrollProxy
            {
                withAnimation(.easeInOut(duration: 1.5)) {
                    proxy.scrollTo(lastMessage.id, anchor: .bottom)
                }
            }
        }
    }
}
