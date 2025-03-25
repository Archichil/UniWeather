//
//  Weather.swift
//  UniWeather
//
//  Created by Daniil on 15.03.25.
//

struct Weather: DecodableType {
    let id: Int
    let main: String
    let description: String
    let icon: String
}
