//
//  PromptTypes.swift
//  UniWeather
//
//  Created by Archichil on 17.03.25.
//

/// An enumeration representing types of prompts that can be sent to the AI service.
///
/// This enum provides static methods to generate prompts for various use cases,
/// such as clothing recommendations based on weather conditions.
enum PromptTypes {
    
    static func getClothesRecomendations(weather: DailyWeather, units: Units) -> String {
        let promptWeather = getWeatherFormatForPrompt(weather: weather)
        return """
        Какую одежду надеть на улицу в \(promptWeather.cityName), \(promptWeather.country)? 
        
        \(getFormattedWeather(weather: promptWeather, units: units))
        
        Дай рекомендации по одежде, обуви и аксессуарам для комфортного выхода на улицу.
        Формат ответа:
        - Погодные условия в формате Сегодня в городе...
        - Одежда 
        - Обувь
        - Аксессуары
        - Полезные советы
        И не использу никаких примеров брендов одежды!
        """
    }
    
    private static func getFormattedWeather(weather: WeatherForPrompt, units: Units) -> String {
        let textUnits = getTextUnits(units: units)
        return """
        Погодные условия: температура днём \(weather.temperature)\(textUnits.tempUnits) (ощущается как \(weather.feelsLike)\(textUnits.tempUnits)), минимальная температура \(weather.tempMin)\(textUnits.tempUnits), максимальная \(weather.tempMax)\(textUnits.tempUnits).
        Влажность: \(weather.humidity)%.
        Ветер: \(weather.windSpeed)\(textUnits.windUnits).
        Облачность: \(weather.cloudiness)%.
        Вероятность осадков: \(weather.precipitation)%.
        Описание погоды: \(weather.weatherDescription).
        """
    }
    
    private static func getTextUnits(units: Units) -> TextUnits {
        var windUnits = ""
        var tempUnits = ""
        switch units {
        case .imperial:
            windUnits = "миль/час"
            tempUnits = "°F"
        case .metric:
            windUnits = "метров/с"
            tempUnits = "°C"
        case .standard:
            windUnits = "м/с"
            tempUnits = "°K"
        }
        return TextUnits(windUnits: windUnits, tempUnits: tempUnits)
    }

    private static func getWeatherFormatForPrompt(weather: DailyWeather) -> WeatherForPrompt {
        return WeatherForPrompt(
            cityName: weather.city.name,
            country: weather.city.country,
            temperature: weather.list[0].temp.day,
            feelsLike: weather.list[0].feelsLike.day,
            tempMin: weather.list[0].temp.min,
            tempMax: weather.list[0].temp.max,
            humidity: weather.list[0].humidity,
            windSpeed: weather.list[0].speed,
            cloudiness: weather.list[0].clouds,
            precipitation: weather.list[0].pop * 100,
            weatherDescription: weather.list[0].weather.first?.description ?? "неизвестно"
        )
    }
}
