//
//  AIViewModel.swift
//  UniWeather
//
//  Created by Daniil on 26.03.25.
//

import SwiftUI
import WeatherService
import AIService

class AIViewModel: ObservableObject {
    @Published var messages: [AIMessage] = []
    @Published var selectedDayIndex = 0
    @Published var selectedPrompt: AvailablePrompts?
    @Published var isFetching = false
    
    private let weatherService = WeatherAPIService()
    private let AIService = AIAPIService()
    
    let coordinates: Coordinates
    
    init(coordinates: Coordinates) {
        self.coordinates = coordinates
    }
    
    @MainActor
    func handleItemClick(_ prompt: AvailablePrompts) {
        messages.append(AIMessage(text: prompt.rawValue, time: formatMessageTime(Date()), isAnswer: false))

        let typingIndicator = AIMessage(text: "Typing.", time: formatMessageTime(Date()), isAnswer: true)
        messages.append(typingIndicator)
        
        startTypingAnimation()
        sendMessage(prompt)
    }
    
    @MainActor
    private func sendMessage(_ prompt: AvailablePrompts) {
        Task { [weak self] in
            guard let self = self else { return }
            self.isFetching = true
            
            let response = await self.fetchAIResponse(for: prompt)
            
            if let lastIndex = self.messages.lastIndex(where: { $0.text.starts(with: "Typing") }) {
                self.messages[lastIndex] = AIMessage(text: response, time: self.formatMessageTime(Date()), isAnswer: true)
            }
            self.isFetching = false
        }
    }
    
    private func fetchAIResponse(for prompt: AvailablePrompts) async -> String {
        // TODO: Change coordinates
        let weather = try? await weatherService.getDailyWeather(coords: coordinates, units: .metric ,count: selectedDayIndex + 1, lang: .ru)
        if let weather {
            let prompt: String = {
                switch prompt {
                case .whatToWear:
                    PromptTypes.getClothesRecommendations(weather: weather, index: selectedDayIndex, units: .metric, lang: .ru)
                case .transportOption:
                    PromptTypes.getTransportRecommendation(weather: weather, index: selectedDayIndex, units: .metric, lang: .ru)
                case .healthTips:
                    PromptTypes.getHealthRecommendations(weather: weather, index: selectedDayIndex, units: .metric, lang: .ru)
                case .exploreNearby:
                    PromptTypes.getPlacesToVisitRecommendations(weather: weather, index: selectedDayIndex, units: .metric, lang: .ru)
                case .enjoyableActivities:
                    PromptTypes.getActivityRecommendations(weather: weather, index: selectedDayIndex, units: .metric, lang: .ru)
                }
            }()
            
            let response = try? await AIService.fetchPromptResponse(prompt: prompt)
            
            return response?.choices.first?.message.content ?? "Произошла ошибка при формировании ответа!"
        }
        return "Произошла ошибка при отправке!"
    }
    
    private func formatMessageTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: date)
    }
    
    private var typingTimer: Timer?

    private func startTypingAnimation() {
        var dots = "."
        
        typingTimer?.invalidate()
        
        typingTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }
            
            if !self.isFetching {
                timer.invalidate()
                return
            }
            
            if let index = self.messages.lastIndex(where: { $0.text.starts(with: "Typing") }) {
                let id = self.messages[index].id;
                self.messages[index] = AIMessage(id: id, text: "Typing" + dots, time: self.formatMessageTime(Date()), isAnswer: true)
            }
            
            dots = dots.count < 3 ? dots + "." : "."
        }
    }
}
