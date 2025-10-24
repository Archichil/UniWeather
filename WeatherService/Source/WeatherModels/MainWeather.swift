public struct MainWeather: Decodable, Sendable {
    public let temp: Double
    public let feelsLike: Double
    public let tempMin: Double
    public let tempMax: Double
    public let pressure: Int
    public let humidity: Int
    public let seaLevel: Int
    public let grndLevel: Int
    public let tempKf: Double?
}
