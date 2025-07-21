//
//  AIViewModel.swift
//  UniWeather
//
//  Created by Daniil on 26.03.25.
//

import AIService
import SwiftUI
import WeatherService
import APIClient

class AIViewModel: ObservableObject {
    @Published var messages: [AIMessage] = []
    @Published var selectedDayIndex = 0
    @Published var selectedPrompt: AvailablePrompts?
    @Published var isFetching = false

    private let weatherService = APIClient(
        baseURL: URL(string: WeatherAPISpec.baseURL)!
    )
    private let AIService = APIClient(baseURL: URL(string: AIAPISpec.baseURL)!)

    let coordinates: Coordinates

    private enum Constants {
        enum Texts {
            static let typing = String(localized: "aiViewModel.typing")
            static let answerFetchingError = String(localized: "aiViewModel.answerFetchingError")
            static let answerSendingError = String(localized: "aiViewModel.answerSendingError")
        }

        enum TimeFormats {
            static let hourMinutes = "HH:mm"
        }
    }

    init(coordinates: Coordinates) {
        self.coordinates = coordinates
    }

    @MainActor
    func handleItemClick(_ prompt: AvailablePrompts, model: AIModels = .deepSeekV3) {
        messages.append(AIMessage(text: prompt.title, time: formatMessageTime(Date()), isAnswer: false))

        let typingIndicator = AIMessage(text: "\(Constants.Texts.typing).", time: formatMessageTime(Date()), isAnswer: true)
        messages.append(typingIndicator)

        startTypingAnimation()
        sendMessage(prompt)
    }

    @MainActor
    private func sendMessage(_ prompt: AvailablePrompts) {
        Task { [weak self] in
            guard let self else { return }
            isFetching = true
            
            var allModelsFailed = true
            
            for model in AIModels.allCases {
                let (response, isSuccess) = await fetchAIResponse(for: prompt, model: model)
                
                if isSuccess {
                    if let lastIndex = messages.lastIndex(where: { $0.text.starts(with: "\(Constants.Texts.typing)") }) {
                        messages[lastIndex] = AIMessage(text: response, time: formatMessageTime(Date()), isAnswer: true)
                    }
                    allModelsFailed = false
                    break
                } else {
                    if let typingIndex = messages.lastIndex(where: { $0.text.starts(with: "\(Constants.Texts.typing)") }) {
                        messages[typingIndex] = AIMessage(text: response, time: formatMessageTime(Date()), isAnswer: true)
                    }

                    let currentModelIndex = AIModels.allCases.firstIndex(of: model) ?? 0
                    if currentModelIndex < AIModels.allCases.count - 1 {
                        try? await Task.sleep(nanoseconds: 1_000_000_000)
                        
                        startTypingAnimation()
                    }
                }
            }
            
            if allModelsFailed {
                messages.append(AIMessage(text: "❌ Все модели недоступны. Попробуйте позже.", time: formatMessageTime(Date()), isAnswer: true))
            }
            
            isFetching = false
        }
    }

    private func fetchAIResponse(for prompt: AvailablePrompts, model: AIModels) async -> (String, Bool) {
        let weather: DailyWeather? = try? await weatherService.sendRequest(
            WeatherAPISpec
                .getDailyWeather(
                    coords: coordinates,
                    units: .metric,
                    cnt: selectedDayIndex + 1,
                    lang: .ru
                )
        )
        
        guard let weather else {
            return (Constants.Texts.answerSendingError, false)
        }
        
        let promptText: String = switch prompt {
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
        
        do {
            let response: ChatCompletionResponse = try await AIService.sendRequest(
                AIAPISpec.getCompletion(prompt: promptText, model: model)
            )
            if let content = response.choices.first?.message.content, !content.isEmpty {
                return (content, true)
            } else {
                return ("⚠️ Модель \(model.rawValue) вернула пустой ответ, пробую следующую...", false)
            }
        } catch {
            return ("⚠️ Модель \(model.rawValue) не отвечает, переходу к следующей...", false)
        }
    }

    private func formatMessageTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.TimeFormats.hourMinutes
        return formatter.string(from: date)
    }

    private var typingTimer: Timer?

    private func startTypingAnimation() {
        var dots = "."
        
        typingTimer?.invalidate()
        
        if !messages.contains(where: { $0.text.starts(with: "\(Constants.Texts.typing)") }) {
            messages.append(AIMessage(text: "\(Constants.Texts.typing)" + dots, time: formatMessageTime(Date()), isAnswer: true))
        }
        
        typingTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] timer in
            guard let self else {
                timer.invalidate()
                return
            }
            
            if !isFetching {
                timer.invalidate()
                return
            }
            
            if let index = messages.lastIndex(where: { $0.text.starts(with: "\(Constants.Texts.typing)") }) {
                let id = messages[index].id
                messages[index] = AIMessage(id: id, text: "\(Constants.Texts.typing)" + dots, time: formatMessageTime(Date()), isAnswer: true)
            }
            
            dots = dots.count < 3 ? dots + "." : "."
        }
    }
}
