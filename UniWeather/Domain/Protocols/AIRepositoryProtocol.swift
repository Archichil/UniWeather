import AIService

protocol AIRepositoryProtocol {
    func getCompletion(prompt: String, model: AIModels) async throws -> ChatCompletionResponse
}
