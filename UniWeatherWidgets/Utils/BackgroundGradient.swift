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
    case "02d", "02n":
        return generateFewCloudsGradient(dt: dt, intervals: intervals)
    case "03d", "03n":
        return generateScatteredCloudsGradient(dt: dt, intervals: intervals)
    case "04d", "04n":
        return generateBrokenCloudsGradient(dt: dt, intervals: intervals)
    case "09d", "10d", "11d", "09n", "10n", "11n":
        return generateStormyGradient(dt: dt, intervals: intervals)
    case "13d", "13n":
        return generateSnowGradient(dt: dt, intervals: intervals)
    case "50d", "50n":
        return generateFogGradient(dt: dt, intervals: intervals)
    default:
        return generateClearSkyGradient(dt: dt, intervals: intervals)
    }
}

private func generateClearSkyGradient(dt: Int, intervals: DayIntervals) -> Gradient {
    if dt < intervals.sunriseMinus1H {
        return Gradient(colors: [Color(hex: "#0A1F3A"), Color(hex: "#3A2D6D")])
        
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

private func generateFewCloudsGradient(dt: Int, intervals: DayIntervals) -> Gradient {
    if dt < intervals.sunriseMinus1H {
        return Gradient(colors: [
            Color(hex: "#0A1F3A"),
            Color(hex: "#3A2D6D"),
            Color(hex: "#4B3B7A")
        ])
        
    } else if dt < intervals.sunrise {
        return Gradient(colors: [
            Color(hex: "#5E4B8B"),
            Color(hex: "#7D6BA0"),
            Color(hex: "#A678A5"),
            Color(hex: "#D9A5B3")
        ])

    } else if dt < intervals.sunrisePlus1H {
        return Gradient(colors: [
            Color(hex: "#1e99eb"),
            Color(hex: "#6BB7E8"),
            Color(hex: "#FF9A8B")
        ])
        
    } else if dt < intervals.sunrisePlus3H {
        return Gradient(colors: [
            Color(hex: "#8AC8F0"),
            Color(hex: "#B3D9F5"),
            Color(hex: "#4AB8D6")
        ])
        
    } else if dt < intervals.sunrisePlus5H {
        return Gradient(colors: [
            Color(hex: "#7DB9E8"),
            Color(hex: "#A5CFF1"),
            Color(hex: "#3A97D9")
        ])
        
    } else if dt > intervals.sunrisePlus5H && dt < intervals.sunsetMinus3H {
        return Gradient(colors: [
            Color(hex: "#8DC9F5"),
            Color(hex: "#C2E0FA"),
            Color(hex: "#5AA9E0")
        ])
        
    } else if dt < intervals.sunsetMinus3H {
        return Gradient(colors: [
            Color(hex: "#8DC9F5"),
            Color(hex: "#B8DCFA"),
            Color(hex: "#3A97D9")
        ])
        
    } else if dt < intervals.sunsetMinus1H {
        return Gradient(colors: [
            Color(hex: "#9AC4EB"),
            Color(hex: "#D4B5D5"),
            Color(hex: "#FF9A8B")
        ])
        
    } else if dt < intervals.sunset {
        return Gradient(colors: [
            Color(hex: "#E8B5C1"),
            Color(hex: "#ff9f91"),
            Color(hex: "#FF9A8B"),
            Color(hex: "#D67B8A")
        ])
        
    } else if dt < intervals.sunsetPlus1H {
        return Gradient(colors: [
            Color(hex: "#C890D0"),
            Color(hex: "#A569BD"),
            Color(hex: "#5D4B8E")
        ])
        
    } else {
        return Gradient(colors: [
            Color(hex: "#4B3B7A"),
            Color(hex: "#3A2D6D"),
            Color(hex: "#0A1F3A")
        ])
    }
}

private func generateScatteredCloudsGradient(dt: Int, intervals: DayIntervals) -> Gradient {
    if dt < intervals.sunriseMinus1H {
        return Gradient(colors: [
            Color(hex: "#0A1F3A"),
            Color(hex: "#3A2D6D"),
            Color(hex: "#5A4A7F")
        ])
        
    } else if dt < intervals.sunrise {
        return Gradient(colors: [
            Color(hex: "#4A3D75"),
            Color(hex: "#7A5D95"),
            Color(hex: "#B28BAE"),
            Color(hex: "#E6A5A0")
        ])
        
    } else if dt < intervals.sunrisePlus1H {
        return Gradient(colors: [
            Color(hex: "#1A8BD8"),
            Color(hex: "#7AB5E0"),
            Color(hex: "#D9A5A5")
        ])
        
    } else if dt < intervals.sunrisePlus3H {
        return Gradient(colors: [
            Color(hex: "#6BB3E0"),
            Color(hex: "#A5C8E8"),
            Color(hex: "#C8D8F0"),
            Color(hex: "#4AA5C8")
        ])
        
    } else if dt < intervals.sunrisePlus5H {
        return Gradient(colors: [
            Color(hex: "#5C9ED8"),
            Color(hex: "#8CB8E0"),
            Color(hex: "#3A8CC0")
        ])
        
    } else if dt > intervals.sunrisePlus5H && dt < intervals.sunsetMinus3H {
        return Gradient(colors: [
            Color(hex: "#6AB0E0"),
            Color(hex: "#B0D0E8"),
            Color(hex: "#7FA8D0"),
            Color(hex: "#4A8CC0")
        ])
        
    } else if dt < intervals.sunsetMinus3H {
        return Gradient(colors: [
            Color(hex: "#7AB0D8"),
            Color(hex: "#B8D0E8"),
            Color(hex: "#5A95C0")
        ])
        
    } else if dt < intervals.sunsetMinus1H {
        return Gradient(colors: [
            Color(hex: "#8CA8D0"),
            Color(hex: "#C8A8C0"),
            Color(hex: "#E88B80")
        ])
        
    } else if dt < intervals.sunset {
        return Gradient(colors: [
            Color(hex: "#C88BA0"),
            Color(hex: "#E67B70"),
            Color(hex: "#D05A60")
        ])
        
    } else if dt < intervals.sunsetPlus1H {
        return Gradient(colors: [
            Color(hex: "#A06BA8"),
            Color(hex: "#6A4A88"),
            Color(hex: "#3A2D6D")
        ])
        
    } else {
        return Gradient(colors: [
            Color(hex: "#4A3D75"),
            Color(hex: "#2A1F55"),
            Color(hex: "#0A0F2A")
        ])
    }
}

private func generateBrokenCloudsGradient(dt: Int, intervals: DayIntervals) -> Gradient {
    if dt < intervals.sunriseMinus1H {
        return Gradient(colors: [
            Color(hex: "#0A0F20"),
            Color(hex: "#2A2345"),
            Color(hex: "#3A2D5A")
        ])
        
    } else if dt < intervals.sunrise {
        return Gradient(colors: [
            Color(hex: "#3A3550"),
            Color(hex: "#5A4D70"),
            Color(hex: "#8A7A95"),
            Color(hex: "#B09AA5")
        ])
        
    } else if dt < intervals.sunrisePlus1H {
        return Gradient(colors: [
            Color(hex: "#4A6D88"),
            Color(hex: "#7A95A8"),
            Color(hex: "#A8B8C0")
        ])
        
    } else if dt < intervals.sunrisePlus3H {
        return Gradient(colors: [
            Color(hex: "#5A7D90"),
            Color(hex: "#8AA5B0"),
            Color(hex: "#B0C0C8"),
            Color(hex: "#6A8DA0")
        ])
        
    } else if dt < intervals.sunrisePlus5H {
        return Gradient(colors: [
            Color(hex: "#6A7D88"),
            Color(hex: "#9AA5B0"),
            Color(hex: "#4A6D80")
        ])
        
    } else if dt > intervals.sunrisePlus5H && dt < intervals.sunsetMinus3H {
        return Gradient(colors: [
            Color(hex: "#7A8A95"),
            Color(hex: "#B0B8C0"),
            Color(hex: "#5A7588")
        ])
        
    } else if dt < intervals.sunsetMinus3H {
        return Gradient(colors: [
            Color(hex: "#7A8D98"),
            Color(hex: "#A8B5C0"),
            Color(hex: "#5A7585")
        ])
        
    } else if dt < intervals.sunsetMinus1H {
        return Gradient(colors: [
            Color(hex: "#8A95A0"),
            Color(hex: "#C0A8A8"),
            Color(hex: "#A07D7D")
        ])
        
    } else if dt < intervals.sunset {
        return Gradient(colors: [
            Color(hex: "#A08A95"),
            Color(hex: "#C07A75"),
            Color(hex: "#805A60")
        ])
        
    } else if dt < intervals.sunsetPlus1H {
        return Gradient(colors: [
            Color(hex: "#6A5A75"),
            Color(hex: "#4A3A55"),
            Color(hex: "#2A1F3A")
        ])
        
    } else {
        return Gradient(colors: [
            Color(hex: "#3A2D45"),
            Color(hex: "#1A0F20"),
            Color(hex: "#0A0A15")
        ])
    }
}

private func generateStormyGradient(dt: Int, intervals: DayIntervals) -> Gradient {
    if dt < intervals.sunriseMinus1H {
        return Gradient(colors: [
            Color(hex: "#050810"),
            Color(hex: "#1A1A30"),
            Color(hex: "#2A2245")
        ])
        
    } else if dt < intervals.sunrise {
        return Gradient(colors: [
            Color(hex: "#2A2535"),
            Color(hex: "#4A3D55"),
            Color(hex: "#6A5D70"),
            Color(hex: "#8A7A85")
        ])
        
    } else if dt < intervals.sunrisePlus1H {
        return Gradient(colors: [
            Color(hex: "#3A5565"),
            Color(hex: "#5A7585"),
            Color(hex: "#7A95A0")
        ])
        
    } else if dt < intervals.sunrisePlus3H {
        return Gradient(colors: [
            Color(hex: "#4A6575"),
            Color(hex: "#6A8595"),
            Color(hex: "#8AA5B0"),
            Color(hex: "#3A5565")
        ])
        
    } else if dt < intervals.sunrisePlus5H {
        return Gradient(colors: [
            Color(hex: "#556570"),
            Color(hex: "#7A8A95"),
            Color(hex: "#2A4555")
        ])
        
    } else if dt > intervals.sunrisePlus5H && dt < intervals.sunsetMinus3H {
        return Gradient(colors: [
            Color(hex: "#657580"),
            Color(hex: "#95A5B0"),
            Color(hex: "#3A5565")
        ])
        
    } else if dt < intervals.sunsetMinus3H {
        return Gradient(colors: [
            Color(hex: "#6A7D85"),
            Color(hex: "#9AADB5"),
            Color(hex: "#4A5D65")
        ])
        
    } else if dt < intervals.sunsetMinus1H {
        return Gradient(colors: [
            Color(hex: "#7A858A"),
            Color(hex: "#B0A8A8"),
            Color(hex: "#8A6D6D")
        ])
        
    } else if dt < intervals.sunset {
        return Gradient(colors: [
            Color(hex: "#8A7D85"),
            Color(hex: "#4A3D55"),
            Color(hex: "#6A5D70"),
            Color(hex: "#603A3A")
        ])
        
    } else if dt < intervals.sunsetPlus1H {
        return Gradient(colors: [
            Color(hex: "#5A4A55"),
            Color(hex: "#3A2A35"),
            Color(hex: "#1A0A15")
        ])
        
    } else {
        return Gradient(colors: [
            Color(hex: "#2A1A25"),
            Color(hex: "#0A0508"),
            Color(hex: "#000004")
        ])
    }
}

private func generateSnowGradient(dt: Int, intervals: DayIntervals) -> Gradient {
    if dt < intervals.sunriseMinus1H {
        return Gradient(colors: [
            Color(hex: "#0A1A2A"),
            Color(hex: "#1A2A3A"),
            Color(hex: "#2A3A4A")
        ])
        
    } else if dt < intervals.sunrise {
        return Gradient(colors: [
            Color(hex: "#2A3A4A"),
            Color(hex: "#4A5A6A"),
            Color(hex: "#7A8A9A"),
            Color(hex: "#A0B0C0")
        ])
        
    } else if dt < intervals.sunrisePlus1H {
        return Gradient(colors: [
            Color(hex: "#5A7A90"),
            Color(hex: "#9AB0C0"),
            Color(hex: "#D0E0E8")
        ])
        
    } else if dt < intervals.sunrisePlus3H {
        return Gradient(colors: [
            Color(hex: "#6A8DA0"),
            Color(hex: "#B0C8D8"),
            Color(hex: "#E0F0F8"),
            Color(hex: "#7A9DA8")
        ])
        
    } else if dt < intervals.sunrisePlus5H {
        return Gradient(colors: [
            Color(hex: "#7A95A8"),
            Color(hex: "#C0D8E8"),
            Color(hex: "#5A7D90")
        ])
        
    } else if dt > intervals.sunrisePlus5H && dt < intervals.sunsetMinus3H {
        return Gradient(colors: [
            Color(hex: "#8AA0B0"),
            Color(hex: "#D0E0E8"),
            Color(hex: "#6A8DA0")
        ])
        
    } else if dt < intervals.sunsetMinus3H {
        return Gradient(colors: [
            Color(hex: "#8AA8B8"),
            Color(hex: "#C0D8E0"),
            Color(hex: "#6A8D98")
        ])
        
    } else if dt < intervals.sunsetMinus1H {
        return Gradient(colors: [
            Color(hex: "#9AA8B0"),
            Color(hex: "#D8C0C0"),
            Color(hex: "#A88A8A")
        ])
        
    } else if dt < intervals.sunset {
        return Gradient(colors: [
            Color(hex: "#A0A8B8"),
            Color(hex: "#D0A0A0"),
            Color(hex: "#886A70")
        ])
        
    } else if dt < intervals.sunsetPlus1H {
        return Gradient(colors: [
            Color(hex: "#6A7A8A"),
            Color(hex: "#4A5A6A"),
            Color(hex: "#2A3A4A")
        ])
        
    } else {
        return Gradient(colors: [
            Color(hex: "#3A4A5A"),
            Color(hex: "#1A2A3A"),
            Color(hex: "#0A1A2A")
        ])
    }
}

private func generateFogGradient(dt: Int, intervals: DayIntervals) -> Gradient {
    if dt < intervals.sunriseMinus1H {
        return Gradient(colors: [
            Color(hex: "#1A1A1A"),
            Color(hex: "#2A2A2A"),
            Color(hex: "#3A3A3A")
        ])
        
    } else if dt < intervals.sunrise {
        return Gradient(colors: [
            Color(hex: "#2A2A2A"),
            Color(hex: "#4A4A4A"),
            Color(hex: "#6A6A6A"),
            Color(hex: "#8A8A8A")
        ])
        
    } else if dt < intervals.sunrisePlus1H {
        return Gradient(colors: [
            Color(hex: "#5A5A5A"),
            Color(hex: "#9A9A9A"),
            Color(hex: "#CACACA")
        ])
        
    } else if dt < intervals.sunrisePlus3H {
        return Gradient(colors: [
            Color(hex: "#6A6A6A"),
            Color(hex: "#B0B0B0"),
            Color(hex: "#7A7A7A")
        ])
        
    } else if dt < intervals.sunrisePlus5H {
        return Gradient(colors: [
            Color(hex: "#7A7A7A"),
            Color(hex: "#C0C0C0"),
            Color(hex: "#5A5A5A")
        ])
        
    } else if dt > intervals.sunrisePlus5H && dt < intervals.sunsetMinus3H {
        return Gradient(colors: [
            Color(hex: "#8A8A8A"),
            Color(hex: "#D0D0D0"),
            Color(hex: "#6A6A6A")
        ])
        
    } else if dt < intervals.sunsetMinus3H {
        return Gradient(colors: [
            Color(hex: "#8D8D8D"),
            Color(hex: "#C5C5C5"),
            Color(hex: "#6D6D6D")
        ])
        
    } else if dt < intervals.sunsetMinus1H {
        return Gradient(colors: [
            Color(hex: "#959595"),
            Color(hex: "#D5C5C5"),
            Color(hex: "#A58A8A")
        ])
        
    } else if dt < intervals.sunset {
        return Gradient(colors: [
            Color(hex: "#A09A9A"),
            Color(hex: "#D0A0A0"),
            Color(hex: "#806A6A")
        ])
        
    } else if dt < intervals.sunsetPlus1H {
        return Gradient(colors: [
            Color(hex: "#6A6A75"),
            Color(hex: "#4A4A55"),
            Color(hex: "#2A2A3A")
        ])
        
    } else {
        return Gradient(colors: [
            Color(hex: "#3A3A3A"),
            Color(hex: "#1A1A1A"),
            Color(hex: "#0A0A0A")
        ])
    }
}
