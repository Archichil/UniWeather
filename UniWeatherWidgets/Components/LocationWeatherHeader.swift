//
//  LocationWeatherHeader.swift
//  UniWeather
//
//  Created by Daniil on 20.04.25.
//

import SwiftUI

struct LocationWeatherHeader: View {
    let location: String
    let icon: String
    let currentTemp: Int
    let tempMin: Int
    let tempMax: Int
    let isCurrentLocation: Bool
    
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                LocationTitle(location: location, textSize: 15, isCurrentLocation: isCurrentLocation)
                
                WeatherIcon(weatherCode: icon)
                    .font(.system(size: 13))
                    .frame(alignment: .trailing)
            }
            
            HStack {
                Text("\(currentTemp)º")
                    .font(.largeTitle)
                    .fontWeight(.regular)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack(alignment: .trailing, spacing: 1) {
                    HStack(spacing: 0) {
                        Image(systemName: "arrow.up")
                            .font(.system(size: 11))
                            .fontWeight(.heavy)
                        
                        Text("\(tempMax)º")
                            .frame(width: 24, alignment: .trailing)
                    }
                    
                    HStack(spacing: 0) {
                        Image(systemName: "arrow.down")
                            .font(.system(size: 11))
                            .fontWeight(.heavy)
                        
                        Text("\(tempMin)º")
                            .frame(width: 24, alignment: .trailing)
                    }
                    .foregroundStyle(secondaryColor)
                }
                .font(.system(size: 13))
                .bold()
            }
        }
        .foregroundStyle(.white)
    }
}
