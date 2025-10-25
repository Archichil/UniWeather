import AIService
import APIClient
import Foundation

final class AIRepository: AIRepositoryProtocol {
    private let apiClient: APIClient

    init(apiClient: APIClient = APIClient(baseURL: URL(string: AIAPISpec.baseURL)!)) {
        self.apiClient = apiClient
    }

    func getCompletion(prompt: String, model: AIModels) async throws -> ChatCompletionResponse {
        try await apiClient.sendRequest(
            AIAPISpec.getCompletion(prompt: prompt, model: model)
        )
    }
}
