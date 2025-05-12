//
//  AvailablePrompts.swift
//  UniWeather
//
//  Created by Daniil on 26.03.25.
//

enum AvailablePrompts: CaseIterable {
    case whatToWear
    case transportOption
    case enjoyableActivities
    case exploreNearby
    case healthTips

    var title: String {
        switch self {
        case .whatToWear:
            return String(localized: "prompt.whatToWear")
        case .transportOption:
            return String(localized: "prompt.transportOption")
        case .enjoyableActivities:
            return String(localized: "prompt.enjoyableActivities")
        case .exploreNearby:
            return String(localized: "prompt.exploreNearby")
        case .healthTips:
            return String(localized: "prompt.healthTips")
        }
    }

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

