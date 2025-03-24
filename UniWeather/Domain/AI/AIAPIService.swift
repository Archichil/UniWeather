//
//  AIAPIService.swift
//  UniWeather
//
//  Created by Archichil on 17.03.25.
//

/// A service class for interacting with the AI API to fetch responses for prompts.
///
/// This class provides methods to send requests to the AI API and retrieve responses.
/// It conforms to the `APIService` protocol and uses an `APIClient` to handle network requests.
///
/// ## Example
/// ```swift
/// let apiClient = APIClient(baseURL: URL(string: "https://openrouter.ai/api/v1")!)
/// let aiService = AIAPIService(apiClient: apiClient)
///
/// Task {
///     do {
///         let response = try await aiService.fetchPromptResponse(prompt: "What is the weather today?")
///         print(response?.choices.first?.message.content ?? "No response")
///     } catch {
///         print("Error: \(error)")
///     }
/// }
/// ```
class AIAPIService: APIService {
    private func fetchAIResponse<T: Decodable>(spec: AIAPISpec) async throws -> T? {
        do {
            return try await apiClient?.sendRequest(spec) as? T
        } catch {
            print("Failed to send request to AI: \(error.localizedDescription)")
            return nil
        }
    }
    
    func fetchPromptResponse(prompt: String) async throws -> ChatCompletionResponse? {
        return try await fetchAIResponse(spec: .getCompletion(prompt: prompt))
    }
}
