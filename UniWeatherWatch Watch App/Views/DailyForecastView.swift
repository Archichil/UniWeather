//
//  DailyForecastView.swift
//  UniWeather
//
//  Created by Daniil on 14.05.25.
//

import SwiftUI

struct DailyForecastView: View {
    @ObservedObject var viewModel: WeatherInfoViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                if let weather = viewModel.dailyWeather {
                    let timezone = weather.city.timezone
                    ForEach(weather.list.indices, id:\.self) { index in
                        let item = weather.list[index]
                        
                        DailyForecastItemView(entry: DailyForecastItem(
                            dt: item.dt + timezone,
                            icon: item.weather.first?.icon ?? "",
                            minTemp: Int((item.temp.min).rounded()),
                            maxTemp: Int((item.temp.max).rounded())
                        ))
                        
                        if (index < weather.list.count - 1) {
                            Divider()
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 8)
    }
}

private struct DailyForecastItemView: View {
    let entry: DailyForecastItem
    
    var body: some View {
        HStack(spacing: 0) {
            Text(getShortWeekday(from: entry.dt))
                .frame(maxWidth: 55, alignment: .leading)
            
            WeatherIconView(weatherCode: entry.icon)
                .font(.system(size: 17))
            
            HStack(alignment: .center, spacing: 0) {
                Text("\(entry.minTemp)º")
                    .foregroundStyle(secondaryColor)
                    .frame(maxWidth: 24, alignment: .leading)
                
                Text("\(entry.maxTemp)º")
                    .frame(maxWidth: 30, alignment: .trailing)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
        }
        .font(.system(size: 15))
        .fontWeight(.semibold)
    }
}

private struct DividerView: View {
    var body: some View {
        Rectangle()
            .frame(maxWidth: .infinity, maxHeight: 1.5)
            .foregroundStyle(.white.opacity(0.4))
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
