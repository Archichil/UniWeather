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
    
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                HStack(spacing: 0) {
                    Text(location)
                        .lineLimit(1)
                        .bold()
                        .font(.system(size: 15))
                    
                    Image(systemName: "location.fill")
                        .font(.system(size: 10))
                        .padding(.horizontal, 2)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                
                Image(systemName: icon)
                    .foregroundStyle(.white, .yellow)
                    .font(.system(size: 16))
                    .frame(alignment: .trailing)
                
            }
            
            HStack {
                Text("\(currentTemp)º")
                    .font(.largeTitle)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack(alignment: .trailing, spacing: 2) {
                    HStack(spacing: 0) {
                        Image(systemName: "arrow.up")
                            .fontWeight(.semibold)
                        
                        Text("\(tempMax)º")
                            .bold()
                            .frame(width: 24, alignment: .trailing)
                    }
                    
                    HStack(spacing: 0) {
                        Image(systemName: "arrow.down")
                            .fontWeight(.semibold)
                        
                        Text("\(tempMin)º")
                            .bold()
                            .frame(width: 24, alignment: .trailing)
                    }
                    .foregroundStyle(secondaryColor)
                }
                .font(.system(size: 12))
            }
        }
        .foregroundStyle(.white)
    }
}
