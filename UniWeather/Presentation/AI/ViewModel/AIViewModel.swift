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
    
    @Published var selectedDay: DaySelection = .Today
    
    func handleItemClick(_ prompt: AvailablePrompts) {
        messages.append(AIMessage(text: prompt.rawValue, time: formatTime(Date()), isAnswer: false))
        
        let typingIndicator = AIMessage(text: "Typing...", time: formatTime(Date()), isAnswer: true)
        messages.append(typingIndicator)
        
//        switch prompt {
//        case .whatToWear:
//            print("Outdoor")
//        case .transportOption:
//            print("Transport")
//        case .enjoyableActivities:
//            print("Activities")
//        case .exploreNearby:
//            print("Places")
//        case .healthTips:
//            print("health")
//        }
        sendMessage(prompt)
    }
    
    private func sendMessage(_ prompt: AvailablePrompts) {
        Task { [weak self] in
            print("send")
            guard let self = self else { return }
            
            let response = await self.fetchAIResponse(for: prompt)
            
            if let lastIndex = self.messages.lastIndex(where: { $0.text == "Typing..." }) {
                self.messages[lastIndex] = AIMessage(text: response, time: self.formatTime(Date()), isAnswer: true)
                print("Updated message at index \(lastIndex): \(self.messages[lastIndex])")
            }
        }
    }
    
    private func fetchAIResponse(for prompt: AvailablePrompts) async -> String {
        try? await Task.sleep(nanoseconds: 2_000_000_000)  // 2 секунды задержки
        return "AI Response for '\(prompt.rawValue)'"
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: date)
    }
}
