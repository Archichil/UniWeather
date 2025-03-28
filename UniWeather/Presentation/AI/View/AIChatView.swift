//
//  PromptDetailView.swift
//  UniWeather
//
//  Created by Daniil on 26.03.25.
//

import SwiftUI

struct AIChatView: View {
    @ObservedObject var viewModel: AIViewModel
    
    @State private var showDropdown = false
    
    var body: some View {
        ZStack {
            if viewModel.messages.isEmpty {
                VStack {
                    Text("The dialog is empty.\nYou can choose the prompt below!")
                        .foregroundStyle(.gray)
                        .multilineTextAlignment(.center)
                        .padding()
                }
                .zIndex(100)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
            
            VStack(spacing: 0) {
                HStack(spacing: 10) {
                    AICircleIcon(
                        icon: "bubble.right",
                        size: 50,
                        bgColor: Color(red: 52 / 255, green: 54 / 255, blue: 58 / 255),
                        iconColor: Color(red: 180 / 255, green: 181 / 255, blue: 188 / 255),
                        font: .title2
                    )
                    
                    VStack(alignment: .leading) {
                        Text(viewModel.messages.count > 1 ? viewModel.messages[viewModel.messages.count - 2].text : "None")
                            .foregroundStyle(.white)
                            .lineLimit(1)
                            .fontWeight(.medium)
                        
                        Text("Last updated \(viewModel.messages.last?.time ?? "")")
                            .foregroundStyle(.gray)
                            .lineLimit(1)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .padding(.horizontal, 7)
                .padding(.bottom, 10)
                .padding(.top)
                
                Rectangle()
                    .frame(maxWidth: .infinity, maxHeight: 1)
                    .foregroundStyle(.gray.opacity(0.5))
                
                ScrollViewReader { proxy in
                    ScrollView {
                        
                        ForEach(viewModel.messages) { message in
                            VStack {
                                AIMessageItem(text: message.text, time: message.time, isAnswer: message.isAnswer)
                            }
                            .padding(message.isAnswer ? .leading : .trailing, 7)
                            .frame(maxWidth: .infinity, alignment: message.isAnswer ? .leading : .trailing)
                        }
                        
                    }
                    .onAppear {
                        if let lastMessage = viewModel.messages.last {
                            proxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.top)
                .background(Color(red: 28 / 255, green: 30 / 255, blue: 31 / 255))
                
                AIChatDropUpMenu(viewModel: viewModel, showDropdown: $showDropdown)
            }
        }
    }
}

#Preview {
    AIView()
}

