//
//  MainView.swift
//  UniWeather
//
//  Created by Daniil on 14.05.25.
//

import SwiftUI

let secondaryColor: Color = .white.opacity(0.5)

struct MainView: View {
    @ObservedObject var viewModel: WeatherInfoViewModel
    var isCurrentLocation: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                HStack {
                    Text(viewModel.currentPlace ?? "Неизвестно")
                        .font(.title3)
                        .fontWeight(.medium)
                        .lineLimit(1)
                    
                    if (isCurrentLocation) {
                        Image(systemName: "location.fill")
                            .font(.caption)
                    }
                }
                
                Text("\(Int(viewModel.currentWeather?.main.temp.rounded() ?? -99))º")
                    .font(.largeTitle)
                    .fontWeight(.regular)
                
                
                Text("\(viewModel.currentWeather?.weather.first?.description ?? "Неизвестно")")
                    .font(.caption)
                    .foregroundStyle(secondaryColor)
                    .fontWeight(.medium)
                
                HStack(spacing: 6) {
                    HStack(spacing: 1) {
                        Image(systemName: "arrow.up")
                            .font(.system(size: 11))
                            .fontWeight(.bold)
                        Text("\(Int((viewModel.dailyWeather?.list.first?.temp.max ?? 99).rounded()))º")
                    }
                    
                    HStack(spacing: 1) {
                        Image(systemName: "arrow.down")
                            .font(.system(size: 12))
                            .fontWeight(.bold)
                        Text("\(Int((viewModel.dailyWeather?.list.first?.temp.min ?? -99).rounded()))º")
                    }
                }
                .font(.system(size: 14))
                .fontWeight(.semibold)
                .padding(.top, 3)
            }.frame(maxHeight: .infinity, alignment: .top)
            
            HStack {
                InfoCircleView(icon: "thermometer.variable", text: "\(Int(viewModel.currentWeather?.main.feelsLike.rounded() ?? -99))º")
                Spacer()
                InfoCircleView(icon: "umbrella.fill", text: "\(Int(viewModel.dailyWeather?.list.first?.rain?.rounded() ?? 0))%")
                Spacer()
                InfoCircleView(icon: "drop.fill", text: "\(Int(viewModel.dailyWeather?.list.first?.humidity ?? 0))%")
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 20)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        }
        .ignoresSafeArea(edges: .bottom)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

private struct InfoCircleView: View {
    let icon: String
    let text: String
    
    var body: some View {
        VStack(spacing: 0) {
            Image(systemName: icon)
            Text(text)
                .padding(.leading, 2)
        }
        .font(.system(size: 11))
        .background(
            Circle().fill(.ultraThinMaterial.opacity(0.4))
                .frame(width: 35, height: 35)
        )
        .frame(width: 35, height: 35)
    }
}
