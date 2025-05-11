//
//  HolidaysForecastView.swift
//  UniWeather
//
//  Created by Daniil on 1.05.25.
//

import SwiftUI

struct HolidaysForecastView: View {
    @StateObject private var viewModel = HolidaysForecastViewModel()
    
    // MARK: - Constants
    private enum Constants {
        enum Colors {
            static let accentColor = Color(hex: "#6557FF")
            static let textPrimary = Color.white.opacity(0.9)
            static let textSecondary = Color.white.opacity(0.6)
            static let backgroundGradient = LinearGradient(
                gradient: Gradient(colors: [
                    Color(hex: "#0F0F2D"),
                    Color(hex: "#1A1A3A")
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
        }
        
        enum Layout {
            static let cardCornerRadius: CGFloat = 20
            static let cardPadding: CGFloat = 16
            static let spacing: CGFloat = 12
            static let largeSpacing: CGFloat = 24
            static let iconSize: CGFloat = 24
            static let tempFontSize: CGFloat = 32
        }
    }
    
    // MARK: - Main View
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                headerView
                
                ScrollView {
                    VStack(alignment: .leading, spacing: Constants.Layout.largeSpacing) {
                        ForEach(viewModel.eventsWithWeather) { holiday in
                            HolidayCard(holiday: holiday)
                        }
                        
                        if viewModel.eventsWithWeather.isEmpty {
                            Text("Ближайших праздников не найдено!")
                                .foregroundStyle(Constants.Colors.textSecondary)
                                .padding(.top, 200)
                        }
                    }
                    .padding(.horizontal, Constants.Layout.cardPadding)
                }
                .padding(.top, Constants.Layout.largeSpacing)
            }
            .frame(maxWidth: .infinity)
            .background(Constants.Colors.backgroundGradient.edgesIgnoringSafeArea(.all))
        }
        .refreshable {
            Task {
                await viewModel.fetchEventsWithWeather()
            }
        }
    }
    
    // MARK: - Subviews
    private var headerView: some View {
        VStack(alignment: .leading, spacing: Constants.Layout.spacing) {
            Text("Праздничный прогноз")
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(Constants.Colors.textPrimary)
            
            Text("Прогноз погоды на ближайшие праздники")
                .font(.system(size: 16))
                .foregroundStyle(Constants.Colors.textSecondary)
        }
    }
    
    private struct HolidayCard: View {
        let holiday: HolidayWeather

        private var dateFormatter: DateFormatter {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy"
            return formatter
        }
        var body: some View {
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: Constants.Layout.cardCornerRadius)
                    .fill(getCardBackground(weatherCode: holiday.icon).opacity(0.9))
                    .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                
                HStack {
                    VStack(alignment: .leading) {
                        Text(holiday.title)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundStyle(Constants.Colors.textPrimary)
                            .frame(maxHeight: .infinity, alignment: .top)
                            .lineLimit(2)
                            
                        VStack(alignment: .leading, spacing: 4) {
                            Text(dateFormatter.string(from: holiday.date))
                                .font(.system(size: 16))
                                .foregroundStyle(Constants.Colors.textPrimary.opacity(0.8))
                            
                            Text(holiday.notes ?? "Нет заметок")
                                .font(.system(size: 14))
                                .foregroundStyle(Constants.Colors.textPrimary.opacity(0.8))
                                .lineLimit(1)
                        }.frame(alignment: .bottom)
                    }
                    .frame(maxHeight: .infinity)
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 6) {
                        VStack(alignment: .trailing, spacing: 1) {
                            WeatherIcon(weatherCode: holiday.icon)
                                .font(.system(size: Constants.Layout.iconSize))
                            
                            Text(holiday.weather.prefix(1).capitalized + holiday.weather.dropFirst())
                                .font(.system(size: 16, weight: .bold))
                                .foregroundStyle(.white)
                                .multilineTextAlignment(.trailing)
                        }
                        .frame(maxHeight: .infinity, alignment: .top)
                        
                        Text("\(holiday.temp)º")
                            .font(.system(size: Constants.Layout.tempFontSize, weight: .regular))
                            .foregroundStyle(.white)
                            .frame(alignment: .bottom)
                    }
                }
                .padding(Constants.Layout.cardPadding)
            }
            .frame(height: 145)
        }
    }
}

// MARK: - WeatherIcon
struct WeatherIcon: View {
    static let weatherIconMap: [String: String] = [
        "sunrise": "sunrise.fill",
        "sunset": "sunset.fill",
        "01d": "sun.max.fill",
        "01n": "moon.stars.fill",
        "02d": "cloud.sun.fill",
        "02n": "cloud.moon.fill",
        "03d": "cloud.fill",
        "03n": "cloud.fill",
        "04d": "cloud.fill",
        "04n": "cloud.fill",
        "09d": "cloud.drizzle.fill",
        "09n": "cloud.drizzle.fill",
        "10d": "cloud.rain.fill",
        "10n": "cloud.rain.fill",
        "11d": "cloud.bolt.rain.fill",
        "11n": "cloud.bolt.rain.fill",
        "13d": "snowflake",
        "13n": "snowflake",
        "50d": "cloud.fog.fill",
        "50n": "cloud.fog.fill",
    ]

    let weatherCode: String

    var body: some View {
        Image(systemName: WeatherIcon.weatherIconMap[weatherCode] ?? "questionmark")
            .symbolRenderingMode(.multicolor)
    }
}

// MARK: - Card background
private func getCardBackground(weatherCode: String) -> Gradient {
    switch weatherCode {
    case "01d", "01n":
        return Gradient(colors: [
            Color(hex: "#6DC8F3"),
            Color(hex: "#4AB8D6")
        ])
    case "02d", "02n":
        return Gradient(colors: [
            Color(hex: "#7DB9E8"),
            Color(hex: "#A5CFF1"),
            Color(hex: "#3A97D9")
        ])
    case "03d", "03n":
        return Gradient(colors: [
            Color(hex: "#6AB0E0"),
            Color(hex: "#B0D0E8"),
            Color(hex: "#7FA8D0"),
            Color(hex: "#4A8CC0")
        ])
    case "04d", "04n":
        return Gradient(colors: [
            Color(hex: "#5A7D90"),
            Color(hex: "#8AA5B0"),
            Color(hex: "#B0C0C8"),
            Color(hex: "#6A8DA0")
        ])
    case "09d", "10d", "11d", "09n", "10n", "11n":
        return Gradient(colors: [
            Color(hex: "#4A6575"),
            Color(hex: "#6A8595"),
            Color(hex: "#8AA5B0"),
            Color(hex: "#3A5565")
        ])
    case "13d", "13n":
        return Gradient(colors: [
            Color(hex: "#2A3A4A"),
            Color(hex: "#4A5A6A"),
            Color(hex: "#7A8A9A"),
            Color(hex: "#A0B0C0")
        ])
    case "50d", "50n":
        return Gradient(colors: [
            Color(hex: "#6A6A6A"),
            Color(hex: "#B0B0B0"),
            Color(hex: "#7A7A7A")
        ])
    default:
        return Gradient(colors: [
            Color(hex: "#6DC8F3"),
            Color(hex: "#4AB8D6")
        ])
    }
}

// MARK: - Preview
#Preview {
    HolidaysForecastView()
}
