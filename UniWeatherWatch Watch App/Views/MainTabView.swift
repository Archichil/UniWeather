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
    
    private var backgroundGradient: LinearGradient {
        LinearGradient(gradient: getBackgroundGradient(weatherCode: viewModel.currentWeather?.weather.first?.icon ?? "01d", dt: viewModel.currentWeather?.dt ?? Int(Date.now.timeIntervalSince1970), sunset: viewModel.dailyWeather?.list.first?.sunset ?? 0, sunrise: viewModel.dailyWeather?.list.first?.sunrise ?? 0), startPoint: .top, endPoint: .bottom)
    }
    
    var body: some View {
        TabView {
            if viewModel.isLoaded {
                MainView(viewModel: viewModel)
                
                HourlyForecastView(viewModel: viewModel)
                    .navigationTitle("Почасовой прогноз")
                
                DailyForecastView(viewModel: viewModel)
                    .navigationTitle("Суточный прогноз")
            }
            
            
        }
        .tabViewStyle(.carousel)
        .frame(maxWidth: .infinity, alignment: .top)
        .ignoresSafeArea(edges: .bottom)
        .background(backgroundGradient)
        .onAppear {
            guard !viewModel.isLoaded else { return }
            Task {
                await viewModel.loadAllWeather()
            }
        }
    }
}


