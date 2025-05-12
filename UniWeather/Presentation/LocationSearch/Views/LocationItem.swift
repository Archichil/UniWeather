//
//  LocationItem.swift
//  UniWeather
//
//  Created by Artur Kukhatskavolets on 11.05.25.
//

import SwiftUI
import WeatherService

struct LocationItem: View {
    let coordinate: Coordinates
    @StateObject private var viewModel: WeatherInfoViewModel
    @State private var currentTime = Date()

    init(coordinate: Coordinates) {
        self.coordinate = coordinate
        _viewModel = StateObject(wrappedValue: WeatherInfoViewModel(coordinate: coordinate))
    }
        
    private var timeString: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.timeZone = TimeZone(secondsFromGMT: viewModel.currentWeather?.timezone ?? 0)
        return formatter.string(from: currentTime)
    }
    
    private var backgroundGradient: LinearGradient {
        LinearGradient(gradient: getBackgroundGradient(weatherCode: viewModel.currentWeather?.weather.first?.icon ?? "01d", dt: viewModel.currentWeather?.dt ?? Int(Date.now.timeIntervalSince1970), sunset: viewModel.dailyWeather?.list.first?.sunset ?? 0, sunrise: viewModel.dailyWeather?.list.first?.sunrise ?? 0), startPoint: .top, endPoint: .bottom)
    }
    
    private enum Constants {
        
        enum Texts {
            static let unknown = "Unknown"
            static let min = "Min"
            static let max = "Max"
        }
        
        enum Defaults {
            static let minTemp: Double = -99
            static let maxTemp: Double = 99
        }
    }

    var body: some View {
        VStack {
            if viewModel.isLoaded {
                NavigationLink {
                    WeatherInfoView(viewModel: viewModel)
                } label: {
                    VStack(spacing: 16) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(viewModel.currentPlace ?? Constants.Texts.unknown)
                                    .font(.title2)
                                
                                Text(timeString)
                                    .font(.subheadline)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .bold()
                            
                            Text("\(Int(viewModel.currentWeather?.main.temp.rounded() ?? Constants.Defaults.minTemp))º")
                                .font(.system(size: 50))
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        .frame(maxWidth: .infinity)
                        
                        HStack {
                            Text("\(viewModel.currentWeather?.weather.first?.description.capitalized ?? Constants.Texts.unknown)")
                                .font(.callout)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("\(Constants.Texts.max): \(Int(viewModel.dailyWeather?.list.first?.temp.max.rounded() ?? Constants.Defaults.maxTemp))º, \(Constants.Texts.min): \(Int(viewModel.dailyWeather?.list.first?.temp.min.rounded() ?? Constants.Defaults.minTemp))º")
                                .font(.callout)
                                .fontWeight(.medium)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 16)
                    .padding(.horizontal)
                    .foregroundStyle(.white)
                    .background(backgroundGradient)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                }
                .buttonStyle(.plain)

            } else {
                skeletonView
            }
        }
        .animation(.smooth(duration: 0.5), value: viewModel.isLoaded)
        .task {
            await viewModel.loadAllWeather()
        }

        .onReceive(
            Timer.publish(every: 30, on: .main, in: .common).autoconnect()
        ) { _ in
            currentTime = Date()
        }
    }
    
    private var skeletonView: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Минск")
                        .font(.title2)
                    
                    Text(timeString)
                        .font(.subheadline)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .bold()
                
                Text("4º")
                    .font(.system(size: 50))
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .frame(maxWidth: .infinity)
            
            HStack {
                Text("Облачно")
                    .font(.callout)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Макс.:4º, мин.:-3º")
                    .font(.callout)
                    .fontWeight(.medium)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
        .padding(.top, 10)
        .padding(.bottom, 16)
        .padding(.horizontal)
        .foregroundStyle(.white)
        .background(.blue)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .redacted(reason: .placeholder)
    }
}

struct LocationItemContainer: View {
    let coordinate: Coordinates

    var body: some View {
        LocationItem(coordinate: coordinate)
    }
}


#Preview {
    LocationItemContainer(coordinate: Coordinates(lat: 53, lon: 16))
}
