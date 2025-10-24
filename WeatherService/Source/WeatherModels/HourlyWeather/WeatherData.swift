public struct WeatherData: Decodable, Sendable {
    public let dt: Int
    public let main: MainWeather
    public let weather: [Weather]
    public let clouds: Clouds
    public let wind: Wind
    public let rain: Rain?
    public let snow: Snow?
    public let visibility: Int?
    public let pop: Double
    public let sys: HourlyWeatherSys
    public let dtTxt: String
}
