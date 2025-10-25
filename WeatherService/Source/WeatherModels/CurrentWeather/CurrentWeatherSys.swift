public struct CurrentWeatherSys: Decodable, Sendable {
    public let type: Int?
    public let id: Int?
    public let message: Double?
    public let country: String
    public let sunrise: Int
    public let sunset: Int
}
