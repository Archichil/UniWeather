//
//  DetailWeatherWidgetView.swift
//  UniWeather
//
//  Created by Daniil on 20.04.25.
//

import SwiftUI
import WidgetKit

private struct DetailWeatherWidgetSection: View {
    let title: String
    let value: Int
    let units: String
    var icon: String? = nil
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .foregroundStyle(.white)
            
            HStack(spacing: 6) {
                if let icon = icon {
                    Image(systemName: icon)
                }
                
                Text("\(value) \(units)")
            }
            .foregroundStyle(secondaryColor)
        }
        .font(.system(size: 13))
        .bold()
    }
}

struct DetailWeatherWidgetView: View {
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 4) {
                LocationWeatherHeader(
                    location: "Минск",
                    icon: "cloud.sun.fill",
                    currentTemp: 19,
                    tempMin: 12,
                    tempMax: 24
                )
                
                VStack(alignment:.leading, spacing: 2) {
                    DetailWeatherWidgetSection(
                        title: "Осадки",
                        value: 30,
                        units: "%",
                        icon: "cloud.rain.fill"
                    )
                    
                    DetailWeatherWidgetSection(
                        title: "Ветер",
                        value: 12,
                        units: "км/ч"
                    )
                }
            }

        }
        .containerBackground(for: .widget) {
            ContainerRelativeShape()
                .fill(Color(.blue).gradient)
        }
    }
}

struct CurrentWeatherWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        DetailWeatherWidgetView()
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
