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
            String(localized: "prompt.whatToWear")
        case .transportOption:
            String(localized: "prompt.transportOption")
        case .enjoyableActivities:
            String(localized: "prompt.enjoyableActivities")
        case .exploreNearby:
            String(localized: "prompt.exploreNearby")
        case .healthTips:
            String(localized: "prompt.healthTips")
        }
    }

    var iconName: String {
        switch self {
        case .whatToWear: "jacket"
        case .transportOption: "bicycle"
        case .enjoyableActivities: "sparkles"
        case .exploreNearby: "building.columns"
        case .healthTips: "bolt.heart.fill"
        }
    }
}
