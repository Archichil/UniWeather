//
//  HolidayWeather.swift
//  UniWeather
//
//  Created by Daniil on 1.05.25.
//

import Foundation

struct HolidayWeather: Identifiable {
    var id: UUID = .init()
    let title: String
    let notes: String?
    let date: Date
    let temp: Int
    let weather: String
    let icon: String
}
