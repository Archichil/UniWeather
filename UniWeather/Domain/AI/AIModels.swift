//
//  AIModels.swift
//  UniWeather
//
//  Created by Archichil on 17.03.25.
//

/// An enumeration representing the available AI models for the API.
///
/// This enum defines the supported AI models that can be used when making requests to the AI API.
/// Each case corresponds to a specific model and its associated API endpoint.
///
/// ## Examples
/// ```swift
/// let model = AIModels.deepSeekV3
/// print(model.rawValue) // Output: "deepseek/deepseek-chat:free"
/// ```
enum AIModels: String {
    case deepSeekV3 = "deepseek/deepseek-chat:free"
    case deepSeekR1 = "deepseek/deepseek-r1:free"
}
