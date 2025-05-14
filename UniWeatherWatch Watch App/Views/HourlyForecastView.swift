//
//  HourlyForecastView.swift
//  UniWeather
//
//  Created by Daniil on 14.05.25.
//

import SwiftUI
import WeatherService

struct HourlyForecastView: View {
    @ObservedObject var viewModel: WeatherInfoViewModel
    
    var body: some View {
        ScrollView{
            VStack(spacing: 16) {
                if let weather = viewModel.hourlyWeather {
                    let items = getItems(items: weather)
                    
                    ForEach(items.indices, id: \.self) { index in
                        let item = items[index]
                        HourlyForecastItemView(entry: item)
                    }
                }

            }
            .padding(.horizontal, 8)
        }
    }
}

private struct HourlyForecastItem {
    let id: UUID = .init()
    let dt: Int
    let icon: String
    let text: String
}

private struct HourlyForecastItemView: View {
    let entry: HourlyForecastItem
    
    var body: some View {
        HStack(spacing: 0) {
            let hour = (entry.dt % 86400) / 3600
            let min = (entry.dt % 3600) / 60
            Text(String(format: "%d:%02d", hour, min))
                .frame(maxWidth: 55, alignment: .leading)
            
            HStack(alignment: .center, spacing: 0) {
                Text(entry.text)
                    .frame(alignment: .trailing)
                
                WeatherIconView(weatherCode: entry.icon)
                    .frame(maxWidth: 35, alignment: .trailing)
                    .font(.system(size: 18))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
        }
        .font(.system(size: 16))
        .fontWeight(.semibold)
    }
}

private func getItems(items: HourlyWeather) -> [HourlyForecastItem] {
    let timezone = items.city.timezone
    var result = items.list.map { item in
        HourlyForecastItem(
            dt: item.dt + timezone,
            icon: item.weather.first?.icon ?? "",
            text: "\(Int(item.main.temp.rounded()))°"
        )
    }
    
    let sunrise = (items.city.sunrise ?? 0) + timezone
    let sunset = (items.city.sunset ?? 0) + timezone
    
    func insertSunEvent(time: Int, type: String) {
        guard time > result.first?.dt ?? Int.max,
              time < result.last?.dt ?? Int.min else { return }
        
        let sunEvent = HourlyForecastItem(
            dt: time,
            icon: type,
            text: type == "sunrise" ? "Рассвет" : "Закат"
        )
        
        if let insertIndex = result.firstIndex(where: { $0.dt > time }) {
            result.insert(sunEvent, at: insertIndex)
        }
    }
    
    [sunrise, sunset].sorted().forEach { time in
        insertSunEvent(time: time, type: time == sunrise ? "sunrise" : "sunset")
    }
    
    return Array(result.prefix(12))
}

#Preview {
    ContentView()
}
