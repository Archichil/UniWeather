//
//  AIViewModel.swift
//  UniWeather
//
//  Created by Daniil on 26.03.25.
//

import SwiftUI

class AIViewModel: ObservableObject {
    @Published var selectedAction: PromptAction?
    
    func handleItemClick(_ action: PromptAction) {
        self.selectedAction = action
        switch action {
        case .whatToWear:
            print("Outdoor")
        case .transportOption:
            print("Transport")
        case .enjoyableActivities:
            print("Activities")
        case .exploreNearby:
            print("Places")
        case .healthTips:
            print("health")
        }
    }
}
