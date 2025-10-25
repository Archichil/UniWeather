import APIClient
import Foundation

/// An enumeration representing the API specifications for interacting with the AI service.
///
/// This enum defines the API endpoints, request methods, headers, and body configurations
/// required to communicate with the AI service. It conforms to the `APIClient.APISpec` protocol.
///
/// ## Example
/// ```swift
/// let spec = AIAPISpec.getCompletion(prompt: "What is the weather today?")
/// let apiClient = APIClient(baseURL: URL(string: "https://openrouter.ai/api/v1")!)
///
/// Task {
///     do {
///         let response = try await apiClient.sendRequest(spec)
///         print(response)
///     } catch {
///         print("Error: \(error)")
///     }
/// }
/// ```
public enum AIAPISpec {
    /// A case for fetching a completion response from the AI service.
    ///
    /// - Parameter prompt: The user's input prompt to send to the AI service.
    case getCompletion(prompt: String, model: AIModels)
}

extension AIAPISpec: APIClient.APISpecification {
    public static let baseURL: String = "https://openrouter.ai/api/v1"

    public var endpoint: String {
        switch self {
        case .getCompletion: "/chat/completions"
        }
    }

    public var method: APIClient.HttpMethod { .post }

    public var queryParameters: [String: String]? { nil }

    public var headers: [String: String]? {
        switch self {
        case .getCompletion:
            [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(apiKey ?? "")",
            ]
        }
    }

    public var body: Data? {
        switch self {
        case let .getCompletion(prompt, model):
            let requestBody: [String: Any] = [
                "model": model.modelName,
                "messages": [
                    [
                        "role": "user",
                        "content": prompt,
                    ],
                ],
            ]
            do {
                return try JSONSerialization.data(withJSONObject: requestBody, options: [])
            } catch {
                print("[DEBUG] Failed to serialize JSON request body: \(error)")
                return nil
            }
        }
    }

    /// The API key required for authentication.
    ///
    /// This property retrieves the API key from the `Config.plist` file.
    /// If the file or key is not found, it logs an error and returns `nil`.
    private var apiKey: String? {
        guard let filePath = Bundle.main.path(forResource: "Config", ofType: "plist") else {
            print("[DEBUG] Config.plist not found.")
            return nil
        }
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "OPENROUTER_AI_API_KEY") as? String else {
            print("[DEBUG] OPENROUTER_AI_API_KEY not found in Config.plist.")
            return nil
        }
        return value
    }
}
