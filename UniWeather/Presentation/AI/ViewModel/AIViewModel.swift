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
    @Published var selectedPrompt: AvailablePrompts?
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
        return """
**Weather conditions**: On 27 March, the weather in Minsk is expected to be cool and rainy, with temperatures around 6°C (feels like 3°C), 100% cloud cover, and a high chance of light rain. Humidity is 80%, and the wind is moderate at 4.03 m/s.  

**Clothing**:  
  - A waterproof or water-resistant jacket.  
  - A warm sweater or fleece for layering.  
  - Long pants or jeans.  
  - A scarf to protect your neck from the wind.  

**Footwear**:  
  - Waterproof boots or shoes with good grip.  
  - Warm socks to keep your feet dry and comfortable.  

**Accessories**:  
  - A compact umbrella.  
  - A hat or beanie to keep your head warm.  
  - Gloves to protect your hands from the cold.  

**Useful tips**:  
  - Layer your clothing to adjust to the changing temperatures throughout the day.  
  - Ensure your outerwear is waterproof to stay dry in the rain.  
  - Check the weather forecast before heading out, as conditions may change.  
  - Keep your accessories handy to stay comfortable in the cool, damp weather.
"""
    }
    
    private func formatMessageTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: date)
    }
}
