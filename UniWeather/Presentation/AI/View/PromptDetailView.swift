//
//  PromptDetailView.swift
//  UniWeather
//
//  Created by Daniil on 26.03.25.
//

import SwiftUI

struct PromptDetailView: View {
    @ObservedObject var viewModel: AIViewModel
    
    @State private var showDropdown = false
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { proxy in
                ScrollView {
                    HStack(spacing: 10) {
                        CircleIcon(icon: "message")
                        
                        VStack(alignment: .leading) {
                            Text(viewModel.messages.last?.text ?? "")
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
                    .padding(.bottom, 4)
                    
                    Rectangle()
                        .frame(maxWidth: .infinity, maxHeight: 1)
                        .foregroundStyle(.gray.opacity(0.5))
                    
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
            
            DropUpMenu(viewModel: viewModel, showDropdown: $showDropdown)
        }
    }
}

#Preview {
    PromptDetailView(viewModel: AIViewModel())
}

