//
//  HourlyWeatherWidgetView.swift
//  UniWeather
//
//  Created by Daniil on 19.04.25.
//

import SwiftUI
import WidgetKit

struct ForecastItem: View {
    var time: String
    
    var body: some View {
        VStack {
            Image(systemName: "cloud.rain.fill")
                .font(.callout)
            Text(time)
                .font(.system(size: 8))
                .bold()
        }.frame(maxWidth: .infinity)
    }
}

struct HourlyWeatherWidgetView: View {
    var entry: HourlyWeatherProvider.Entry
    
    var body: some View {
        ZStack {
            VStack() {
                HStack() {
                    VStack(alignment: .leading) {
                        Text("Cloudy with")
                            .font(.headline)
                            .lineLimit(2)
                        
                        Text("32º")
                            .font(.title2)
//                            .padding(.top, 1)
//                            .frame(maxHeight: .infinity, alignment: .bottom)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .fontWeight(.bold)
                    
                    Image(systemName: "cloud.sun.fill")
                        .font(.title)
                        .foregroundStyle(.white, .yellow)
                        .frame(maxHeight: .infinity, alignment: .topTrailing)
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                
                VStack {
                    
                    HStack(spacing: 2) {
                        Image(systemName: "mappin.and.ellipse")
                            .font(.footnote)
                        
                        Text("MINSK")
                            .bold()

                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.caption)

                    
                    HStack(spacing: 2) {
                        Image(systemName: "calendar")
                            .font(.footnote)
                        
                        Text("SAT APR 19")
                            .bold()

                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.caption)
                    .padding(.bottom, 1)
                    
                    HStack {
                        ForecastItem(time: "18:00")
                        
                        ForecastItem(time: "19:00")
                        
                        ForecastItem(time: "20:00")
                        
                        ForecastItem(time: "21:00")
                    }
                    .frame(maxWidth: .infinity)
                    

                }
                .frame(maxWidth: .infinity, alignment: .bottom)

            }
            .padding(.vertical, 8)
            .padding(.horizontal, 10)
            .foregroundStyle(.white)
        }
        .containerBackground(for: .widget) {
            ContainerRelativeShape()
                .fill(Color(.blue).gradient)
        }
    }
}

struct WeatherSmallWidget_Previews: PreviewProvider {
    static var previews: some View {
        HourlyWeatherWidgetView(
            entry: WeatherEntry(
                date: Date(),
                temperature: 23,
                condition: "partlycloudy",
                location: "Москва"
            )
        )
        .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
