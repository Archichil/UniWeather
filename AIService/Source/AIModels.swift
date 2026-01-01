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
    case xiaomiMimoV2
    case deepSeekR1
    case gemini20FlashExperimental
    case qwen3Coder

    public var modelName: String {
        switch self {
        case .xiaomiMimoV2:
            "xiaomi/mimo-v2-flash:free"
        case .deepSeekR1:
            "deepseek/deepseek-r1-0528:free"
        case .gemini20FlashExperimental:
            "google/gemini-2.0-flash-exp:free"
        case .qwen3Coder:
            "qwen/qwen3-coder:free"
        }
    }
}
