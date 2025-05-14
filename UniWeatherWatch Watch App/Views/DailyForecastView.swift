//
//  DailyForecastView.swift
//  UniWeather
//
//  Created by Daniil on 14.05.25.
//

import SwiftUI

private struct DividerView: View {
    var body: some View {
        Rectangle()
            .frame(maxWidth: .infinity, maxHeight: 1.5)
            .foregroundStyle(.white.opacity(0.4))
    }
}

private struct DailyForecastItemView: View {
    var body: some View {
            HStack(spacing: 0) {
                Text(getShortWeekday(from: Int(Date.now.timeIntervalSince1970)))
                    .frame(maxWidth: 55, alignment: .leading)

                WeatherIconView(weatherCode: "02d")
                    .font(.system(size: 17))

                HStack(alignment: .center, spacing: 0) {
                    Text("\(12)º")
                        .foregroundStyle(secondaryColor)
                        .frame(maxWidth: 24, alignment: .leading)

                    Text("\(24)º")
                        .frame(maxWidth: 30, alignment: .trailing)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
            }
            .font(.system(size: 15))
            .fontWeight(.semibold)
            

    }
}

struct DailyForecastView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                DailyForecastItemView()
                Divider()
                DailyForecastItemView()
                Divider()
                DailyForecastItemView()
                Divider()
                DailyForecastItemView()
                Divider()
                DailyForecastItemView()
                Divider()
                DailyForecastItemView()
                Divider()
                DailyForecastItemView()
                Divider()
                DailyForecastItemView()
            }
        }
        .padding(.horizontal, 8)
    }
}

private func getShortWeekday(from timestamp: Int) -> String {
    let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ru_RU")
    formatter.dateFormat = "E"
    return formatter.string(from: date).capitalized
}


#Preview {
    ContentView()
}
