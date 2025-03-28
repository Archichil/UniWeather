//
//  AIViewModel.swift
//  UniWeather
//
//  Created by Daniil on 26.03.25.
//

import SwiftUI

@MainActor
class AIViewModel: ObservableObject {
    @Published var messages: [AIMessage] = []
    @Published var selectedDayIndex = 0
    @Published var isFetching = false
    
    func handleItemClick(_ prompt: AvailablePrompts) {
        messages.append(AIMessage(text: prompt.rawValue, time: formatMessageTime(Date()), isAnswer: false))
        
        let typingIndicator = AIMessage(text: "Typing...", time: formatMessageTime(Date()), isAnswer: true)
        messages.append(typingIndicator)
        
        sendMessage(prompt)
    }
    
    private func sendMessage(_ prompt: AvailablePrompts) {
        Task { [weak self] in
            guard let self = self else { return }
            self.isFetching = true
            
            let response = await self.fetchAIResponse(for: prompt)
            
            if let lastIndex = self.messages.lastIndex(where: { $0.text == "Typing..." }) {
                self.messages[lastIndex] = AIMessage(text: response, time: self.formatMessageTime(Date()), isAnswer: true)
            }
            self.isFetching = false
        }
    }
    
    private func fetchAIResponse(for prompt: AvailablePrompts) async -> String {
        try? await Task.sleep(nanoseconds: 10_000_000_000)
        return "AI Response for '\(prompt.rawValue)'"
    }
    
    private func formatMessageTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: date)
    }
}
