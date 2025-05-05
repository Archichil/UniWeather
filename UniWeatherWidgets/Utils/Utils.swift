//
//  Utils.swift
//  UniWeather
//
//  Created by Daniil on 5.05.25.
//

import Foundation
import SwiftUI

let secondaryColor: Color = .white.opacity(0.5)

// TODO: DELETE AFTER ADDING SHARED FRAMEWORK
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64

        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (255, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

func getShortWeekday(from timestamp: Int) -> String {
    let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ru_RU")
    formatter.dateFormat = "E"
    return formatter.string(from: date).capitalized
}

func itemsWithSunEvents(
    items: [HourlyWeatherHourItem],
    count: Int,
    sunrise: Int,
    sunset: Int,
    dt: Int
) -> [HourlyWeatherHourItem] {
    var result = items

    func insert(type: String, time: Int) {
        let sunEventItem = HourlyWeatherHourItem(
            dt: time,
            icon: type,
            temp: nearestTemp(for: time, in: result),
            isSunsetOrSunrise: true
        )

        if time > result.last?.dt ?? 0 {
            return
        }

        let insertIndex = result.firstIndex(where: { $0.dt > time }) ?? result.count
        
        if insertIndex == 0 {
            result.insert(sunEventItem, at: insertIndex)
        } else if insertIndex == result.count {
            result.append(sunEventItem)
        } else {
            result.insert(sunEventItem, at: insertIndex)
        }

        if result.count > count {
            result.removeLast()
        }
    }

    func nearestTemp(for time: Int, in items: [HourlyWeatherHourItem]) -> Int {
        items.min(by: { abs($0.dt - time) < abs($1.dt - time) })?.temp ?? 0
    }

    if let first = items.first?.dt, let last = items.last?.dt {
        let extendedStart = first - 3600
        let extendedEnd = last + 3600

        if sunrise >= extendedStart && sunrise <= extendedEnd && sunrise >= dt {
            insert(type: "sunrise", time: sunrise)
        }

        if sunset >= extendedStart && sunset <= extendedEnd && sunset >= dt {
            insert(type: "sunset", time: sunset)
        }
    }

    return result.sorted(by: { $0.dt < $1.dt })
}
