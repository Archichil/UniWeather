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
            "deepseek/deepseek-chat-v3-0324:free"
        case .deepSeekR1:
            "deepseek/deepseek-r1-0528-qwen3-8b:free"
        case .gemini20FlashExperimental:
            "google/gemini-2.0-flash-exp:free"
        case .metaLlama4Maverick:
            "meta-llama/llama-4-maverick:free"
        }
    }
}
