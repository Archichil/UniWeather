//
//  BackgroundGradient.swift
//  UniWeather
//
//  Created by Daniil on 30.04.25.
//

import SwiftUI

struct DayIntervals {
    let sunrise: Int
    let sunset: Int
    let sunriseMinus1H: Int
    let sunrisePlus1H: Int
    let sunrisePlus3H: Int
    let sunrisePlus5H: Int
    let sunsetMinus3H: Int
    let sunsetMinus1H: Int
    let sunsetPlus1H: Int
}

private func getDayIntervals(sunset: Int, sunrise: Int) -> DayIntervals {
    return DayIntervals(
        sunrise: sunrise,
        sunset: sunset,
        sunriseMinus1H: sunrise - 3600 * 1,
        sunrisePlus1H: sunrise + 3600,
        sunrisePlus3H: sunrise + 3600 * 3,
        sunrisePlus5H: sunrise + 3600 * 5,
        sunsetMinus3H: sunset - 3600 * 3,
        sunsetMinus1H: sunset - 3600 * 1,
        sunsetPlus1H: sunset + 3600
    )
}

func getBackgroundGradient(weatherCode: String, dt: Int, sunset: Int, sunrise: Int) -> Gradient {
    let intervals = getDayIntervals(sunset: sunset, sunrise: sunrise)
    switch weatherCode {
    case "01d", "01n":
        return generateClearSkyGradient(dt: dt, intervals: intervals)
    default:
        return generateClearSkyGradient(dt: dt, intervals: intervals)
    }
}

func generateClearSkyGradient(dt: Int, intervals: DayIntervals) -> Gradient {
    if dt < intervals.sunriseMinus1H {
        return Gradient(colors: [Color(hex: "#0A1F3A"), Color(hex: "#3A2D6D")]) // +
        
    } else if dt < intervals.sunrise {
        return Gradient(colors: [
            Color(hex: "#5E4B8B"),
            Color(hex: "#A678A5"),
            Color(hex: "#FF9A8B")
        ])

        
    } else if dt < intervals.sunrisePlus1H {
        return Gradient(colors: [
            Color(hex: "#1e99eb"),
            Color(hex: "#FF9A8B")
        ])
        
    } else if dt < intervals.sunrisePlus3H {
        return Gradient(colors: [
            Color(hex: "#6DC8F3"),
            Color(hex: "#4AB8D6")
        ])
        
    } else if dt < intervals.sunrisePlus5H {
        return Gradient(colors: [
            Color(hex: "#47ABE8"),
            Color(hex: "#3A97D9")
        ])
        
    } else if dt > intervals.sunrisePlus5H && dt < intervals.sunsetMinus3H {
        return Gradient(colors: [
            Color(hex: "#6ac2f7"),
            Color(hex: "#3A97D9")
        ])
        
    } else if dt < intervals.sunsetMinus3H {
        return Gradient(colors: [
            Color(hex: "#6ac2f7"),
            Color(hex: "#3A97D9")
        ])
        
    } else if dt < intervals.sunsetMinus1H {
        return Gradient(colors: [
            Color(hex: "#7AB8EB"),
            Color(hex: "#FF9A8B")
        ])
        
    } else if dt < intervals.sunset {
        return Gradient(colors: [
            Color(hex: "#ff9f91"),
            Color(hex: "#FF9A8B"),
            Color(hex: "#fc7460")
        ])
        
    } else if dt < intervals.sunsetPlus1H {
        return Gradient(colors: [
            Color(hex: "#A569BD"),
            Color(hex: "#3A2D6D")])
        
    } else {
        return Gradient(colors: [Color(hex: "#3A2D6D"), Color(hex: "#0A1F3A")])
    }
}

