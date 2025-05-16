//
//  MainTabView.swift
//  UniWeather
//
//  Created by Daniil on 14.05.25.
//

import SwiftUI
import WeatherService

struct MainTabView: View {
    @ObservedObject var viewModel: WeatherInfoViewModel
    var isCurrentLocation: Bool = false
    
    private var backgroundGradient: LinearGradient {
        LinearGradient(gradient: getBackgroundGradient(weatherCode: viewModel.currentWeather?.weather.first?.icon ?? "01d", dt: viewModel.currentWeather?.dt ?? Int(Date.now.timeIntervalSince1970), sunset: viewModel.dailyWeather?.list.first?.sunset ?? 0, sunrise: viewModel.dailyWeather?.list.first?.sunrise ?? 0), startPoint: .top, endPoint: .bottom)
    }
    
    var body: some View {
        TabView {
            if viewModel.isLoaded {
                MainView(viewModel: viewModel, isCurrentLocation: isCurrentLocation)
                
                WindView(viewModel: viewModel)
                    .navigationTitle("Ветер")
                
                HourlyForecastView(viewModel: viewModel)
                    .navigationTitle("Почасовой прогноз")
                
                DailyForecastView(viewModel: viewModel)
                    .navigationTitle("Суточный прогноз")
            } else {
                MainView(viewModel: viewModel)
                    .redacted(reason: .placeholder)
                    .background(getBackgroundGradient(weatherCode: "01d", dt: 10000, sunset: 20000, sunrise: 0))
                    .onAppear {
                        Task {
                            await viewModel.loadAllWeather(loadGeo: false)
                        }
                    }
            }
        }
        .tabViewStyle(.carousel)
        .frame(maxWidth: .infinity, alignment: .top)
        .ignoresSafeArea(edges: .bottom)
        .background(backgroundGradient)
        .onAppear {
            guard !viewModel.isLoaded else { return }
            Task {
                await viewModel.loadAllWeather(loadGeo: false)
            }
        }
    }
}


