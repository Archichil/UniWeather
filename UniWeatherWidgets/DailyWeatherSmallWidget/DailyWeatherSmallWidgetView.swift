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
    let day: String
    let icon: String
    let tempMin, tempMax: Int
    
    var body: some View {
        HStack {
            HStack(spacing: 0) {
                Text(day)
                    .frame(maxWidth: 26, alignment: .leading)
                
                Image(systemName: icon)
                    .foregroundStyle(.white, .yellow)

            }
            .font(.system(size: 13))
            .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: 0) {
                Text("\(tempMin)")
                    .foregroundStyle(secondaryColor)
                
                Text("\(tempMax)º")
                    .foregroundStyle(.white)
                    .frame(maxWidth: 26, alignment: .trailing)
            }
            .font(.system(size: 13))
        }
        .frame(maxWidth: .infinity)
        .bold()
    }
}

struct DailyWeatherSmallWidgetView: View {
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                LocationWeatherHeader(
                    location: "Минск",
                    icon: "cloud.sun.fill",
                    currentTemp: 19,
                    tempMin: 12,
                    tempMax: 24
                )

                
                VStack(spacing: 2) {
                    DailyWeatherRow(day: "Пн", icon: "cloud.sun.fill", tempMin: 10, tempMax: 21)
                    DailyWeatherRow(day: "Вт", icon: "cloud.fill", tempMin: 11, tempMax: 22)
                    DailyWeatherRow(day: "Ср", icon: "cloud.rain.fill", tempMin: 12, tempMax: 23)
                    DailyWeatherRow(day: "Чт", icon: "sun.max", tempMin: 13, tempMax: 24)
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

struct DailyWeatherSmall_Previews: PreviewProvider {
    static var previews: some View {
        DailyWeatherSmallWidgetView()
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
