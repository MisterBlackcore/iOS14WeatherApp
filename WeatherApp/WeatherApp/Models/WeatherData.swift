import Foundation

struct WeatherData: Codable {
    let current: CurrentWeather
    let hourly: [HourlyWeather]
    let daily: [DailyWeather]
}

struct CurrentWeather: Codable {
    let temp: Double
    let sunrise: Int
    let sunset: Int
    let humidity: Int
    let wind_speed: Double
    let feels_like: Double
    let pressure: Int
    let visibility: Int
    let uvi: Double
    let weather: [Weather]
}

struct DailyWeather: Codable {
    let dt: Int
    let temp: Temperature
    let pop: Double
    let weather: [Weather]
    let sunrise: Int
    let sunset: Int
}

struct Temperature: Codable {
    let min: Double
    let max: Double
}

struct Weather: Codable {
    let description: String
    let icon: String
}

struct HourlyWeather: Codable {
    let dt: Int
    let temp: Double
    let pop: Double
    let weather: [Weather]
}

