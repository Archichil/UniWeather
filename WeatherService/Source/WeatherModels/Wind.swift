public struct Wind: Decodable, Sendable {
    public let speed: Double
    public let deg: Int
    public let gust: Double?
}
