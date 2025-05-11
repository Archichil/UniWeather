//
//  AvailablePrompts.swift
//  UniWeather
//
//  Created by Daniil on 26.03.25.
//

enum AvailablePrompts: String, CaseIterable {
    case whatToWear = "What to wear for outdoor activities?"
    case transportOption = "Which transport option suits the weather?"
    case enjoyableActivities = "What enjoyable activities are perfect for this weather?"
    case exploreNearby = "Where to explore based on the weather?"
    case healthTips = "Health tips for staying comfortable."
    
    var iconName: String {
        switch self {
        case .whatToWear: return "jacket"
        case .transportOption: return "bicycle"
        case .enjoyableActivities: return "sparkles"
        case .exploreNearby: return "building.columns"
        case .healthTips: return "bolt.heart.fill"
        }
    }
}
