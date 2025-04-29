//
//  LargeLocationWeatherHeader.swift
//  UniWeather
//
//  Created by Daniil on 22.04.25.
//

import SwiftUI
import WidgetKit

struct LargeLocationWeatherHeader: View {
    let location: String
    let icon: String
    let weather: String
    let currentTemp: Int
    let tempMin: Int
    let tempMax: Int
    let isCurrentLocation: Bool
    
    var body: some View {
        VStack(spacing: 1) {
            HStack(spacing: 0) {
                LocationTitle(location: location, textSize: 15, isCurrentLocation: isCurrentLocation)
                
                WeatherIcon(weatherCode: icon)
                    .font(.system(size: 16))
                    .frame(alignment: .trailing)
            }
            
            HStack {
                Text("\(currentTemp)º")
                    .font(.largeTitle)
                    .fontWeight(.regular)
                
                VStack(alignment: .trailing, spacing: 1) {
                    Text(weather.prefix(1).capitalized + weather.dropFirst())
                    
                    HStack(spacing: 1) {
                        Image(systemName: "arrow.down")
                            .font(.system(size: 11))
                            .fontWeight(.heavy)
                        Text("\(tempMin)º")
                        
                        Image(systemName: "arrow.up")
                            .font(.system(size: 11))
                            .fontWeight(.heavy)
                        Text("\(tempMax)º")
                    }
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .font(.system(size: 13))
            }
            .bold()
        }
        .frame(maxWidth: .infinity)
    }
}

//struct LargeLocationWeatherHeader_Previews: PreviewProvider {
//    static var previews: some View {
//        HourlyWeatherWidgetView()
//            .previewContext(WidgetPreviewContext(family: .systemMedium))
//    }
//}

