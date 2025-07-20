public struct ChatCompletionResponse: Decodable {
    public let id: String
    public let created: Int
    public let choices: [Choice]
}
