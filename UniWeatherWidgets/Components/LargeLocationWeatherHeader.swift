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
    
    var body: some View {
        VStack(spacing: 1) {
            HStack(spacing: 0) {
                LocationTitle(location: location, textSize: 20)
                
                Image(systemName: icon)
                    .foregroundStyle(.white, .yellow)
                    .font(.system(size: 20))
                    .frame(alignment: .trailing)
            }
            
            HStack {
                Text("\(currentTemp)º")
                    .font(.largeTitle)
                
                VStack(alignment: .trailing, spacing: 1) {
                    Text(weather)
                    
                    HStack(spacing: 4) {
                        HStack(spacing: 1) {
                            Image(systemName: "arrow.down")
                            Text("\(tempMin)º")
                        }
                        
                        HStack(spacing: 1) {
                            Image(systemName: "arrow.up")
                            Text("\(tempMax)º")
                        }
                    }
                    .font(.system(size: 15))
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .fontWeight(.semibold)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

struct LargeLocationWeatherHeader_Previews: PreviewProvider {
    static var previews: some View {
        HourlyWeatherWidgetView()
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}

