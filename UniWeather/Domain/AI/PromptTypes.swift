//
//  PromptTypes.swift
//  UniWeather
//
//  Created by Archichil on 17.03.25.
//

import Foundation

/// An enumeration representing types of prompts that can be sent to the AI service.
///
/// This enum provides static methods to generate prompts for various use cases,
/// such as clothing recommendations based on weather conditions.
enum PromptTypes {
    
    /// Generates a prompt for clothing recommendations based on the provided weather.
    ///
    /// - Parameters:
    ///   - weather: The daily weather data.
    ///   - index: The index of day in `DailyWeather` list.
    ///   - units: The units of measurement (e.g., metric or imperial).
    ///   - lang: The language in which the response should be generated.
    /// - Returns: A string representing the prompt for the AI service.
    static func getClothesRecomendations(weather: DailyWeather, index: Int, units: Units, lang: Language) -> String {
        let promptWeather = getWeatherFormatForPrompt(weather: weather.list[index])
        let date = Date(timeIntervalSince1970: TimeInterval(weather.list[index].dt))
        
        return """
        Ответь на \(lang == Language.en ? "английском" : "русском") языке
        На основе предоставленных погодных условий предложи какую одежду 
        надеть на улицу в \(weather.city.name), \(weather.city.country)? 
        Вот погода на день \(date)
        \(getFormattedWeather(weather: promptWeather, units: units))
        
        Дай рекомендации по одежде, обуви и аксессуарам для комфортного выхода на улицу.
        Формат ответа:
        - Погодные условия: пару предложений в формате число месяц(в строковом формате) ожидается погода в городе... и тд
        - Одежда (в виде списка)
        - Обувь (в виде списка)
        - Аксессуары (в виде списка)
        - Полезные советы
        И не использу никаких примеров брендов одежды!
        """
    }
    
    /// Generates a prompt for activity recommendations based on the provided weather.
    ///
    /// - Parameters:
    ///   - weather: The daily weather data.
    ///   - index: The index of day in `DailyWeather` list.
    ///   - units: The units of measurement (e.g., metric or imperial).
    ///   - lang: The language in which the response should be generated.
    /// - Returns: A string representing the prompt for the AI service.
    static func getActivityRecomendations(weather: DailyWeather, index: Int, units: Units, lang: Language) -> String {
        let promptWeather = getWeatherFormatForPrompt(weather: weather.list[index])
        let date = Date(timeIntervalSince1970: TimeInterval(weather.list[index].dt))
        
        return """
        Ответь на \(lang == Language.en ? "английском" : "русском") языке
        На основе предоставленных погодных условий предложи несколько подходящих 
        вариантов активностей(в общем) в \(weather.city.name), \(weather.city.country)
        Вот погода на день \(date)
        \(getFormattedWeather(weather: promptWeather, units: units))
        
        Учитывай предоставленные данные. Если погода комфортная, отдай предпочтение активностям на свежем воздухе. 
        Иначе, отдай предпочтение активностям без долгого нахождения вне помещений. 
        Выведи список от 5 до 10 рекомендаций с кратким пояснением, почему они подходят под текущие условия.
        Формат ответа:
        - Погодные условия: пару предложений в формате число месяц(в строковом формате) ожидается погода в городе... и тд
        - Рекомендации
        - Краткий вывод
        """
    }
    
    /// Generates a prompt for transport recommendations based on the provided weather.
    ///
    /// - Parameters:
    ///   - weather: The daily weather data.
    ///   - index: The index of day in `DailyWeather` list.
    ///   - units: The units of measurement (e.g., metric or imperial).
    ///   - lang: The language in which the response should be generated.
    /// - Returns: A string representing the prompt for the AI service.
    static func getTransportRecommendation(weather: DailyWeather, index: Int, units: Units, lang: Language) -> String {
        let promptWeather = getWeatherFormatForPrompt(weather: weather.list[index])
        let date = Date(timeIntervalSince1970: TimeInterval(weather.list[index].dt))
        
        return """
        Ответь на \(lang == Language.en ? "английском" : "русском") языке
        На основе предоставленных погодных условий предложи рекомендации по выбору вида 
        транспорта для жителей \(weather.city.name), \(weather.city.country).
        Вот погода на день \(date)
        \(getFormattedWeather(weather: promptWeather, units: units))
        
        Дай рекомендации по выбору транспорта, учитывая предоставленную информацию о погоде.
        
        Формат ответа:
        - Погодные условия: пару предложений в формате число месяц(в строковом формате) ожидается погода в городе... и тд
        - Виды транспорта (например, велосипед, автомобиль, общественный транспорт, пешие прогулки и тд.)
        - Рекомендации по выбору транспорта с учётом погоды
        """
    }

    /// Generates a prompt for health recommendations based on the provided weather.
    ///
    /// - Parameters:
    ///   - weather: The daily weather data.
    ///   - index: The index of day in `DailyWeather` list.
    ///   - units: The units of measurement (e.g., metric or imperial).
    ///   - lang: The language in which the response should be generated.
    /// - Returns: A string representing the prompt for the AI service.
    static func getHealthRecomendations(weather: DailyWeather, index: Int, units: Units, lang: Language) -> String {
        let promptWeather = getWeatherFormatForPrompt(weather: weather.list[index])
        let date = Date(timeIntervalSince1970: TimeInterval(weather.list[index].dt))
        
        return """
        Ответь на \(lang == Language.en ? "английском" : "русском") языке
        На основе текущих погодных условий предложи рекомендации 
        по здоровью для жителей \(weather.city.name), \(weather.city.country)
        Вот погода на день \(date)
        \(getFormattedWeather(weather: promptWeather, units: units))
        
        Учитывай следующие данные о погоде:
        - Температура днём
        - Влажность
        - Ветер
        - Облачность
        - Вероятность осадков
        
        Дай рекомендации, как защитить себя от негативных последствий погодных условий, с учётом предоставленных данных.
        
        Формат ответа:
        - Погодные условия: пару предложений в формате число месяц(в строковом формате) ожидается погода в городе... и тд
        - Рекомендации по защите от жары или холода
        - Советы по дыханию или активности на улице
        - Советы по защите кожи и глаз от погодных факторов
        - Полезные советы для людей с хроническими заболеваниями
        - Полезные советы для людей разных возрастных категорий
        """
    }
    
    /// Generates a prompt for places to visit recommendations based on the provided weather.
    ///
    /// - Parameters:
    ///   - weather: The daily weather data.
    ///   - index: The index of day in `DailyWeather` list.
    ///   - units: The units of measurement (e.g., metric or imperial).
    ///   - lang: The language in which the response should be generated.
    /// - Returns: A string representing the prompt for the AI service.
    static func getPlacesToVisitRecomendations(weather: DailyWeather, index: Int, units: Units, lang: Language) -> String {
        let promptWeather = getWeatherFormatForPrompt(weather: weather.list[index])
        let date = Date(timeIntervalSince1970: TimeInterval(weather.list[index].dt))
        
        return """
        Ответь на \(lang == Language.en ? "английском" : "русском") языке
        На основе текущих погодных условий предложи, какие места можно посетить в городе 
        \(weather.city.name), \(weather.city.country), чтобы максимально насладиться днем.
        
        Вот погода на день \(date)
        \(getFormattedWeather(weather: promptWeather, units: units))
        
        Формат ответа:
        - Погодные условия: пару предложений в формате число месяц(в строковом формате) ожидается погода в городе... и тд.
        - Рекомендации (список от 5 до 10 рекомендаций с кратким пояснением, почему они подходят под текущие условия).
        - Краткий вывод.
        """
    }
    
    /// Formats the weather information into a string suitable for prompts.
    ///
    /// - Parameters:
    ///   - weather: The weather data to be formatted.
    ///   - units: The units of measurement (e.g., metric or imperial).
    /// - Returns: A formatted string containing weather details.
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
    
    /// Converts the unit type to corresponding text units.
    ///
    /// - Parameters:
    ///   - units: The units to be used for measurement (imperial, metric, or standard).
    /// - Returns: A struct containing the text units for wind and temperature.
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
            windUnits = "метров/с"
            tempUnits = "°K"
        }
        return TextUnits(windUnits: windUnits, tempUnits: tempUnits)
    }

    /// Converts the weather data for a specific day into a format for prompts.
    ///
    /// - Parameters:
    ///   - weather: The weather data for a specific day.
    /// - Returns: A formatted weather structure for prompts.
    private static func getWeatherFormatForPrompt(weather: WeatherDay) -> WeatherForPrompt {
        return WeatherForPrompt(
            temperature: weather.temp.day,
            feelsLike: weather.feelsLike.day,
            tempMin: weather.temp.min,
            tempMax: weather.temp.max,
            humidity: weather.humidity,
            windSpeed: weather.speed,
            cloudiness: weather.clouds,
            precipitation: weather.pop * 100,
            weatherDescription: weather.weather.first?.description ?? "неизвестно"
        )
    }
}

