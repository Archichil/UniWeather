public struct DailyWeather: Decodable, Sendable {
    public let city: City
    public let cod: String
    public let message: Double
    public let cnt: Int
    public let list: [WeatherDay]
}
