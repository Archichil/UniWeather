//
//  CurrentWeatherWidgetView.swift
//  UniWeather
//
//  Created by Daniil on 21.04.25.
//

import SwiftUI
import WidgetKit

struct CurrentWeatherWidgetView: View {
    var entry: CurrentWeatherEntry
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 0) {
                LocationTitle(location: entry.location, textSize: 15, isCurrentLocation: entry.isCurrentLocation)
                
                Text("\(entry.temperature)º")
                    .font(.largeTitle)
                    .fontWeight(.regular)
                
                VStack(alignment: .leading, spacing: 2) {
                    WeatherIcon(weatherCode: entry.icon)
                        .font(.system(size: 15))
                    
                    Text(entry.description.prefix(1).capitalized + entry.description.dropFirst())
                        .font(.system(size: 13))
                        .bold()
                        .lineLimit(2)
                }
                .frame(maxHeight: .infinity, alignment: .bottom)
                
                HStack(spacing: 1) {
                    Image(systemName: "arrow.down")
                        .font(.system(size: 11))
                        .fontWeight(.heavy)
                    Text("\(entry.minTemp)º")
                    
                    Image(systemName: "arrow.up")
                        .font(.system(size: 11))
                        .fontWeight(.heavy)
                    Text("\(entry.maxTemp)º")
                }
                .font(.system(size: 13))
                .padding(.top, 2)
                
            }
            .bold()
            .foregroundStyle(.white)

        }
        .containerBackground(for: .widget) {
            ContainerRelativeShape()
                .fill(Color(.blue).gradient)
        }
    }
}

//struct CurrentWeatherWidgetView_Previews: PreviewProvider {
//    static var previews: some View {
//        CurrentWeatherWidgetView()
//            .previewContext(WidgetPreviewContext(family: .systemSmall))
//    }
//}
