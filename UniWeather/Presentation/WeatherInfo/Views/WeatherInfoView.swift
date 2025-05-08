//
//  WeatherInfoView.swift
//  UniWeather
//
//  Created by Artur Kukhatskavolets on 2.05.25.
//

import SwiftUI
import WeatherService

struct WeatherInfoView: View {
    @ObservedObject var viewModel: WeatherInfoViewModel
    @State var offset: CGFloat = 0
    var topEdge: CGFloat
    
    private var backgroundGradient: LinearGradient {
        LinearGradient(gradient: getBackgroundGradient(weatherCode: viewModel.currentWeather?.weather.first?.icon ?? "01d", dt: viewModel.currentWeather?.dt ?? Int(Date.now.timeIntervalSince1970), sunset: viewModel.dailyWeather?.list.first?.sunset ?? 0, sunrise: viewModel.dailyWeather?.list.first?.sunrise ?? 0), startPoint: .top, endPoint: .bottom)
    }
    
    var body: some View {
        ZStack {
            if viewModel.isLoaded {
                backgroundGradient
                    .ignoresSafeArea()
            }
            
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    if viewModel.isLoaded {
                        VStack(alignment: .center, spacing: 5) {
                            Text(viewModel.currentPlace ?? "Unknown")
                                .font(.system(size: 35))
                                .opacity(getOpacity(threshold: 9))
                            Text("\(Int(viewModel.currentWeather?.main.temp.rounded() ?? -50))º")
                                .font(.system(size: 95))
                                .fontWeight(.thin)
                                .opacity(getOpacity(threshold: 12))
                            Text("\(viewModel.currentWeather?.weather.first?.description.capitalized ?? "Unknown")")
                                .font(.title2)
                                .foregroundStyle(.secondary)
                                .opacity(getOpacity(threshold: 15))
                            Text("Max: \(Int(viewModel.dailyWeather?.list.first?.temp.max.rounded() ?? 55))º, min: \(Int(viewModel.dailyWeather?.list.first?.temp.min.rounded() ?? -55))º")
                                .font(.title3)
                                .opacity(getOpacity(threshold: 20))
                        }
                        
                         VStack(spacing: 8) {
                             if let hourlyWeather = viewModel.hourlyWeather,
                                let dailyWeather = viewModel.dailyWeather,
                                let currentWeather = viewModel.currentWeather,
                                let currentAirPollution = viewModel.airPollution {
                                 HourlyForecastSectionView(hourlyWeather: hourlyWeather, sunrise: hourlyWeather.city.sunrise, sunset: hourlyWeather.city.sunset)
                                 WeekForecastSectionView(dailyWeather: dailyWeather)
                                 AirQualitySectionView(currentAirPollution: currentAirPollution)
                                 WindSectionView(currentWeather: currentWeather)
                                 HStack(alignment: .top) {
                                     TemperatureFeelsLikeSection(currentWeather: currentWeather)
                                     HumiditySection(currentWeather: currentWeather)
                                 }
                                 .frame(maxHeight: .infinity)
                                 .frame(height: 160)
                             }
                        }
                        
                        Rectangle()
                            .frame(width: 0, height: 50)
                    } else {
                        ProgressView()
                    }
                }
                .padding(.top, topEdge + 20)
                .padding([.horizontal, .bottom])
                .overlay {
                    GeometryReader { proxy -> Color in
                        let minY = proxy.frame(in: .named("scroll")).minY
                        
                        DispatchQueue.main.async {
                            self.offset = minY
                        }
                        
                        return Color.clear
                    }
                }
            }
            .coordinateSpace(name: "scroll")
            
            Text(viewModel.currentPlace ?? "Unknown")
                .lineLimit(1)
                .font(.system(size: 35))
                .opacity(1 - getOpacity(threshold: 20))
                .frame(maxHeight: .infinity, alignment: .top)
                .padding(.top, topEdge + 10)
                .padding(.horizontal)
            
            VStack {
                Spacer()
                HStack(spacing: 0) {
                    Button(action: {
                        print("")
                    }, label: {
                        Image(systemName: "map")
                            .font(.title2)
                    })
                    .buttonStyle(.plain)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .frame(height: 20)
                    .padding(.horizontal, 32)
                    .padding(.top, 8)
                    .background(.ultraThinMaterial)
                    .background(backgroundGradient)
                    
                    Button(action: {
                        print("")
                    }, label: {
                        Image(systemName: "bubble.left.and.text.bubble.right")
                            .font(.title2)
                    })
                    .buttonStyle(.plain)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    .frame(height: 20)
                    .padding(.top, 8)
                    .background(.ultraThinMaterial)
                    .background(backgroundGradient)
                    
                    Button(action: {
                        print("")
                    }, label: {
                        Image(systemName: "list.dash")
                            .font(.title2)
                    })
                    .buttonStyle(.plain)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                    .frame(height: 20)
                    .padding(.top, 8)
                    .padding(.horizontal, 32)
                    .background(.ultraThinMaterial)
                    .background(backgroundGradient)
                }
            }
        }
        .task {
            await viewModel.loadAllWeather()
        }
    }
    
    private func getTitleOffset() -> CGFloat {
        if offset < 0 {
            let progress = -offset / 145
            return (progress <= 1.0 ? progress : 1) * -20
        }
        return 0
    }
    
    private func getOpacity(threshold: CGFloat) -> CGFloat {
        let titleOffset = -getTitleOffset()
        let progress = titleOffset / threshold
        let opacity = 1 - progress
        return max(0, min(opacity, 1))
    }
}

struct WeatherInfoViewWrapper: View {
    let coordinates: Coordinates
    
    var body: some View {
        GeometryReader { proxy in
            let topEdge = proxy.safeAreaInsets.top
            WeatherInfoView(viewModel: WeatherInfoViewModel(coordinate: coordinates), topEdge: topEdge)
                .ignoresSafeArea(.all, edges: .top)
        }
    }
}

#Preview("Honolulu, Hawaii (GMT-10)") {
    WeatherInfoViewWrapper(coordinates: Coordinates(lat: 21.315603, lon: -157.858093))
}

#Preview("Anchorage, Alaska (GMT-9)") {
    WeatherInfoViewWrapper(coordinates: Coordinates(lat: 61.2181, lon: -149.9003))
}

#Preview("Los Angeles, California (GMT-8)") {
    WeatherInfoViewWrapper(coordinates: Coordinates(lat: 34.0522, lon: -118.2437))
}

#Preview("Denver, Colorado (GMT-7)") {
    WeatherInfoViewWrapper(coordinates: Coordinates(lat: 39.7392, lon: -104.9903))
}

#Preview("New York, USA (GMT-5)") {
    WeatherInfoViewWrapper(coordinates: Coordinates(lat: 40.7128, lon: -74.0060))
}

#Preview("London, UK (GMT+0)") {
    WeatherInfoViewWrapper(coordinates: Coordinates(lat: 51.5074, lon: -0.1278))
}

#Preview("Minsk, Belarus (GMT+3)") {
    WeatherInfoViewWrapper(coordinates: Coordinates(lat: 53.893009, lon: 27.567444))
}

#Preview("Dubai, UAE (GMT+4)") {
    WeatherInfoViewWrapper(coordinates: Coordinates(lat: 25.2048, lon: 55.2708))
}

#Preview("Tokyo, Japan (GMT+9)") {
    WeatherInfoViewWrapper(coordinates: Coordinates(lat: 35.6762, lon: 139.6503))
}

#Preview("Sydney, Australia (GMT+10)") {
    WeatherInfoViewWrapper(coordinates: Coordinates(lat: -33.8688, lon: 151.2093))
}

#Preview("Petropavlovsk-Kamchatskiy, Russia (GMT+12)") {
    WeatherInfoViewWrapper(coordinates: Coordinates(lat: 53.04, lon: 158.65))
}
