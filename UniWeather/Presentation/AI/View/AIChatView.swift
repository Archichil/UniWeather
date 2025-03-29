//
//  PromptDetailView.swift
//  UniWeather
//
//  Created by Daniil on 26.03.25.
//

import SwiftUI

struct AIChatView: View {
    // MARK: - Constants
    private enum Constants {
        enum Colors {
            static let background = Color(red: 28/255, green: 30/255, blue: 31/255)
            static let bubbleBackground = Color(red: 52/255, green: 54/255, blue: 58/255)
            static let icon = Color(red: 180/255, green: 181/255, blue: 188/255)
            static let text = Color.white
            static let secondaryText = Color.gray
            static let divider = Color.gray.opacity(0.5)
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
            static let emptyDialog = "The dialog is empty.\nYou can choose the prompt below!"
            static let noPreviousMessage = "No messages"
            static let lastUpdatedPrefix = "Last updated "
        }
        
        enum Icons {
            static let chatIcon: String = "bubble.right"
        }
    }
    
    // MARK: - Properties
    @ObservedObject var viewModel: AIViewModel
    @State private var showDropdown = false
    @Environment(\.dismiss) var dismiss
    
    // MARK: - Views
    var body: some View {
        ZStack {
            emptyStateView
            mainChatView
        }
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
            }
        }
    }
    
    private var mainChatView: some View {
        VStack(spacing: Constants.Layout.vericalSpacing) {
            headerView
            dividerView
            messagesListView
            AIChatDropUpMenu(viewModel: viewModel, showDropdown: $showDropdown)
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
                    Text("\(Constants.Text.lastUpdatedPrefix)\(viewModel.messages.last?.time ?? "")")
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
    }
    
    private var dividerView: some View {
        Rectangle()
            .frame(maxWidth: .infinity, maxHeight: Constants.Layout.dividerHeight)
            .foregroundStyle(Constants.Colors.divider)
    }
    
    private var messagesListView: some View {
        ScrollViewReader { proxy in
            ScrollView {
                ForEach(viewModel.messages) { message in
                    AIMessageItem(
                        text: message.text,
                        time: message.time,
                        isAnswer: message.isAnswer
                    )
                    .padding(message.isAnswer ? .leading : .trailing, Constants.Layout.horizontalPadding)
                    .frame(maxWidth: .infinity, alignment: message.isAnswer ? .leading : .trailing)
                }
            }
            .onAppear {
                scrollToBottom(proxy: proxy)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.top)
        .background(Constants.Colors.background)
    }
    
    // MARK: - Helper Properties
    private var previousMessageText: String {
        viewModel.messages.count > 1 ? viewModel.messages[viewModel.messages.count - 2].text : Constants.Text.noPreviousMessage
    }
    
    // MARK: - Helper Methods
    private func scrollToBottom(proxy: ScrollViewProxy) {
        if let lastMessage = viewModel.messages.last {
            proxy.scrollTo(lastMessage.id, anchor: .bottom)
        }
    }
}

// MARK: - Preview
#Preview {
    AIView()
}

