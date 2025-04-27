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
                LocationTitle(location: entry.location, textSize: 15)
                
                Text("\(entry.temperature)º")
                    .font(.largeTitle)
                
                
                Image(systemName: "cloud.sun.fill")
                    .foregroundStyle(.white, .yellow)
                    .font(.system(size: 15))
                
                Text("Временами облачно")
                    .padding(.top, 1)
                    .font(.system(size: 13))
                    .bold()
                    .lineLimit(2)
                    .frame(maxHeight: .infinity)
                
                
                HStack(spacing: 2) {
                    Image(systemName: "arrow.down")
                    
                    Text("\(entry.minTemp)º")
                    
                    Image(systemName: "arrow.up")
                    
                    Text("\(entry.maxTemp)º")
                }
                .padding(.top, 3)
                .font(.system(size: 12))
                .bold()
                
            }
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
