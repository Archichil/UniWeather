//
//  AIAPISpec.swift
//  UniWeather
//
//  Created by Archichil on 17.03.25.
//

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
enum AIAPISpec: APIClient.APISpec {
    
    /// A case for fetching a completion response from the AI service.
    ///
    /// - Parameter prompt: The user's input prompt to send to the AI service.
    case getCompletion(prompt: String)
    
    /// The path for the API endpoint.
    private var path: String {
        switch self {
        case .getCompletion: return "/chat/completions"
        }
    }
    
    var endpoint: String {
        return path
    }
    
    var method: APIClient.HttpMethod { .post }
    
    var returnType: DecodableType.Type {
        switch self {
        case .getCompletion: return ChatCompletionResponse.self
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .getCompletion:
            return [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(apiKey ?? "")"
            ]
        }
    }
    
    /// The API key required for authentication.
    ///
    /// This property retrieves the API key from the `Config.plist` file.
    /// If the file or key is not found, it logs an error and returns `nil`.
    private var apiKey: String? {
        get {
            guard let filePath = Bundle.main.path(forResource: "Config", ofType: "plist") else {
                print("Config.plist not found.")
                return nil
            }
            let plist = NSDictionary(contentsOfFile: filePath)
            guard let value = plist?.object(forKey: "OPENROUTER_AI_API_KEY") as? String else {
                print("OPENROUTER_AI_API_KEY not found in Config.plist.")
                return nil
            }
            return value
        }
    }
    
    var body: Data? {
        switch self {
        case .getCompletion(let prompt):
            let requestBody: [String: Any] = [
                "model": "deepseek/deepseek-chat:free",
                "messages": [
                    [
                        "role": "user",
                        "content": prompt
                    ]
                ]
            ]
            do {
                return try JSONSerialization.data(withJSONObject: requestBody, options: [])
            } catch {
                print("Failed to serialize JSON request body: \(error)")
                return nil
            }
        }
    }
}
