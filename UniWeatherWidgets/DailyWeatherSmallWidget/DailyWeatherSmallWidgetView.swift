//
//  DailyWeatherSmallWidgetView.swift
//  UniWeather
//
//  Created by Daniil on 20.04.25.
//

import SwiftUI
import WidgetKit


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

let secondaryColor: Color = Color(hex: "#b2c8eb")

private struct DailyWeatherRow: View {
    let item: DailyWeatherItem
    
    var body: some View {
        HStack {
            HStack(spacing: 0) {
                Text(getShortWeekday(from: item.dt))
                    .frame(maxWidth: 26, alignment: .leading)
                
                WeatherIcon(weatherCode: item.icon)

            }
            .font(.system(size: 13))
            .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: 0) {
                Text("\(item.minTemp)")
                    .foregroundStyle(secondaryColor)
                
                Text("\(item.maxTemp)º")
                    .foregroundStyle(.white)
                    .frame(maxWidth: 26, alignment: .trailing)
            }
            .font(.system(size: 13))
        }
        .frame(maxWidth: .infinity)
        .bold()
    }
    
    private func getShortWeekday(from timestamp: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "E"
        return formatter.string(from: date).capitalized
    }
}

struct DailyWeatherSmallWidgetView: View {
    let entry: DailyWeatherSmallEntry
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                LocationWeatherHeader(
                    location: entry.location,
                    icon: entry.icon,
                    currentTemp: entry.temp,
                    tempMin: entry.minTemp,
                    tempMax: entry.maxTemp,
                    isCurrentLocation: entry.isCurrentLocation
                )
                
                VStack(spacing: 2) {
                    ForEach(entry.items, id: \.dt) { item in
                        DailyWeatherRow(item: item)
                    }
                }
                .frame(maxHeight: .infinity, alignment: .bottom)
                .padding(.top, 2)
            }
            .foregroundStyle(.white)
        }
        .containerBackground(for: .widget) {
            ContainerRelativeShape()
                .fill(Color(.blue).gradient)
        }
    }
}
