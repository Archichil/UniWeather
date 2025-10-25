import WeatherService

protocol WeatherRepositoryProtocol {
    func getCurrentWeather(coords: Coordinates, units: Units?, lang: Language?) async throws -> CurrentWeather
    func getHourlyWeather(coords: Coordinates, units: Units?, cnt: Int?, lang: Language?) async throws -> HourlyWeather
    func getDailyWeather(coords: Coordinates, units: Units?, cnt: Int?, lang: Language?) async throws -> DailyWeather
    func getCurrentAirPollution(coords: Coordinates) async throws -> AirPollution
}