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
    var isNavigationBarHidden = false

    private var backgroundGradient: LinearGradient {
        LinearGradient(gradient: getBackgroundGradient(weatherCode: viewModel.currentWeather?.weather.first?.icon ?? "01d", dt: viewModel.currentWeather?.dt ?? Int(Date.now.timeIntervalSince1970), sunset: viewModel.dailyWeather?.list.first?.sunset ?? 0, sunrise: viewModel.dailyWeather?.list.first?.sunrise ?? 0), startPoint: .top, endPoint: .bottom)
    }

    private enum Constants {
        enum Icons {
            static let map = "map"
            static let AI = "bubble.left.and.text.bubble.right"
            static let savedLocations = "list.dash"
            static let holidayCalendar = "calendar"
        }

        enum Texts {
            static let unknown = String(localized: "weatherInfoView.unknown")
            static let min = String(localized: "weatherInfoView.min")
            static let max = String(localized: "weatherInfoView.max")
            static let coordinateSpace = "scroll"
        }

        enum Defaults {
            static let minTemp: Double = -99
            static let maxTemp: Double = 99
        }
    }

    var body: some View {
        NavigationStack {
            GeometryReader { proxy in
                let topEdge = proxy.safeAreaInsets.top

                ZStack {
                    if viewModel.isLoaded {
                        backgroundGradient
                            .ignoresSafeArea()
                        ScrollView(.vertical, showsIndicators: false) {
                            VStack {
                                mainText
                                weatherData
                                Rectangle()
                                    .frame(width: 0, height: 50)
                            }
                            .padding(.top, topEdge + 20)
                            .padding([.horizontal, .bottom])
                            .overlay {
                                GeometryReader { proxy -> Color in
                                    let minY = proxy.frame(in: .named(Constants.Texts.coordinateSpace)).minY

                                    DispatchQueue.main.async {
                                        offset = minY
                                    }

                                    return Color.clear
                                }
                            }
                        }
                        .coordinateSpace(name: Constants.Texts.coordinateSpace)

                        Text(viewModel.currentPlace ?? Constants.Texts.unknown)
                            .lineLimit(1)
                            .font(.system(size: 35))
                            .opacity(1 - getOpacity(threshold: 20))
                            .frame(maxHeight: .infinity, alignment: .top)
                            .padding(.top, topEdge + 10)
                            .padding(.horizontal)

                        bottomNavigationBar
                    } else {
                        LinearGradient(gradient: getBackgroundGradient(weatherCode: "01d", dt: 10000, sunset: 20000, sunrise: 0), startPoint: .top, endPoint: .bottom)
                            .ignoresSafeArea()
                        skeletonView
                    }
                }
                .ignoresSafeArea(.all, edges: .top)
                .animation(.smooth(duration: 0.5), value: viewModel.isLoaded)
            }
            .toolbar(.hidden, for: .navigationBar)
        }
        .onAppear {
            // only kick off the first load; coming back won’t re-run
            guard !viewModel.isLoaded else { return }
            Task {
                await viewModel.loadAllWeather()
            }
        }
    }

    private var skeletonView: some View {
        VStack(spacing: 20) {
            VStack(alignment: .center, spacing: 5) {
                Text("Sometexttoplace")
                    .font(.system(size: 35))
                Text("SS")
                    .font(.system(size: 95))
                    .fontWeight(.thin)
                Text("some text")
                    .font(.title2)
                    .foregroundStyle(.secondary)
                Text("some text some ")
                    .font(.title3)
            }

            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray.opacity(0.3))
                .frame(height: 150)

            ForEach(0 ..< 3) { _ in
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 200)
            }
        }
        .background(getBackgroundGradient(weatherCode: "01d", dt: 10000, sunset: 20000, sunrise: 0))
        .ignoresSafeArea()
        .padding(.top, 80)
        .padding(.horizontal)
        .redacted(reason: .placeholder)
        .transition(.identity)
    }

    private var mainText: some View {
        VStack(alignment: .center, spacing: 5) {
            Text(viewModel.currentPlace ?? Constants.Texts.unknown)
                .font(.system(size: 35))
                .opacity(getOpacity(threshold: 9))
            Text("\(Int(viewModel.currentWeather?.main.temp.rounded() ?? Constants.Defaults.minTemp))º")
                .font(.system(size: 95))
                .fontWeight(.thin)
                .opacity(getOpacity(threshold: 12))
            Text("\(viewModel.currentWeather?.weather.first?.description.capitalized ?? Constants.Texts.unknown)")
                .font(.title2)
                .foregroundStyle(.secondary)
                .opacity(getOpacity(threshold: 15))
            Text("\(Constants.Texts.max): \(Int(viewModel.dailyWeather?.list.first?.temp.max.rounded() ?? Constants.Defaults.maxTemp))º, \(Constants.Texts.min): \(Int(viewModel.dailyWeather?.list.first?.temp.min.rounded() ?? Constants.Defaults.minTemp))º")
                .font(.title3)
                .opacity(getOpacity(threshold: 20))
        }
    }

    private var weatherData: some View {
        VStack(spacing: 8) {
            if let hourlyWeather = viewModel.hourlyWeather,
               let dailyWeather = viewModel.dailyWeather,
               let currentWeather = viewModel.currentWeather,
               let currentAirPollution = viewModel.airPollution
            {
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
    }

    private var bottomNavigationBar: some View {
        VStack {
            Spacer()
            HStack(spacing: 0) {
                NavigationLink {
                    WeatherMapContainerView()
                } label: {
                    Image(systemName: Constants.Icons.map)
                        .font(.title2)
                }
                .buttonStyle(.plain)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .frame(height: 20)
                .padding(.horizontal, 32)
                .padding(.top, 8)
                .background(.ultraThinMaterial)
                .background(backgroundGradient)

                NavigationLink {
                    AIView(viewModel: AIViewModel(coordinates: viewModel.coordinate))
                } label: {
                    Image(systemName: Constants.Icons.AI)
                        .font(.title2)
                }
                .buttonStyle(.plain)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .frame(height: 20)
                .padding(.top, 8)
                .background(.ultraThinMaterial)
                .background(backgroundGradient)

                NavigationLink {
                    HolidaysForecastView(coordinates: viewModel.coordinate)
                } label: {
                    Image(systemName: Constants.Icons.holidayCalendar)
                        .font(.title2)
                }
                .buttonStyle(.plain)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .frame(height: 20)
                .padding(.top, 8)
                .padding(.horizontal, 32)
                .background(.ultraThinMaterial)
                .background(backgroundGradient)

                NavigationLink {
                    LocationSearchView()
                } label: {
                    Image(systemName: Constants.Icons.savedLocations)
                        .font(.title2)
                }
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

#Preview("Honolulu, Hawaii (GMT-10)") {
    WeatherInfoView(viewModel: WeatherInfoViewModel(coordinate: Coordinates(lat: 21.315603, lon: -157.858093)))
}

#Preview("Anchorage, Alaska (GMT-9)") {
    WeatherInfoView(viewModel: WeatherInfoViewModel(coordinate: Coordinates(lat: 61.2181, lon: -149.9003)))
}

#Preview("Los Angeles, California (GMT-8)") {
    WeatherInfoView(viewModel: WeatherInfoViewModel(coordinate: Coordinates(lat: 34.0522, lon: -118.2437)))
}

#Preview("Denver, Colorado (GMT-7)") {
    WeatherInfoView(viewModel: WeatherInfoViewModel(coordinate: Coordinates(lat: 39.7392, lon: -104.9903)))
}

#Preview("New York, USA (GMT-5)") {
    WeatherInfoView(viewModel: WeatherInfoViewModel(coordinate: Coordinates(lat: 40.7128, lon: -74.0060)))
}

#Preview("London, UK (GMT+0)") {
    WeatherInfoView(viewModel: WeatherInfoViewModel(coordinate: Coordinates(lat: 51.5074, lon: -0.1278)))
}

#Preview("Minsk, Belarus (GMT+3)") {
    WeatherInfoView(viewModel: WeatherInfoViewModel(coordinate: Coordinates(lat: 53.893009, lon: 27.567444)))
}

#Preview("Dubai, UAE (GMT+4)") {
    WeatherInfoView(viewModel: WeatherInfoViewModel(coordinate: Coordinates(lat: 25.2048, lon: 55.2708)))
}

#Preview("Tokyo, Japan (GMT+9)") {
    WeatherInfoView(viewModel: WeatherInfoViewModel(coordinate: Coordinates(lat: 35.6762, lon: 139.6503)))
}

#Preview("Sydney, Australia (GMT+10)") {
    WeatherInfoView(viewModel: WeatherInfoViewModel(coordinate: Coordinates(lat: -33.8688, lon: 151.2093)))
}

#Preview("Petropavlovsk-Kamchatskiy, Russia (GMT+12)") {
    WeatherInfoView(viewModel: WeatherInfoViewModel(coordinate: Coordinates(lat: 53.04, lon: 158.65)))
}
