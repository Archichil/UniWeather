/// An enumeration representing the available AI models for the API.
///
/// This enum defines the supported AI models that can be used when making requests to the AI API.
/// Each case corresponds to a specific model and its associated API endpoint.
///
/// ## Examples
/// ```swift
/// let model = AIModels.deepSeekV3
/// print(model.modelName) // Output: "deepseek/deepseek-chat:free"
/// ```
public enum AIModels: String, Sendable, CaseIterable {
    case deepSeekV3
    case deepSeekR1
    case gemini20FlashExperimental
    case metaLlama4Maverick
    
    public var modelName: String {
        switch self {
        case .deepSeekV3:
            return "deepseek/deepseek-chat:free"
        case .deepSeekR1:
            return "deepseek/deepseek-r1:free"
        case .gemini20FlashExperimental:
            return "google/gemini-2.0-flash-exp:free"
        case .metaLlama4Maverick:
            return "meta-llama/llama-4-maverick:free"
        }
    }
}
