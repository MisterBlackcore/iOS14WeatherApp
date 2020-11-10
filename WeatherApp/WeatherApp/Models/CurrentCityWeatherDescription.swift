import Foundation

struct CurrentCityWeatherDescription: Codable{
    var countryName: String?
    var cityName: String?
    var weatherDescription: String?
    var currentTemperature: Int?
    var maxTemperature: Int?
    var minTemperature: Int?
    var sunrise: Int?
    var sunset: Int?
    var pop: Double?
    var humidity: Int?
    var windSpeed: Double?
    var feels_like: Double?
    var rainOneH: Double?
    var pressure: Int?
    var visibility: Int?
    var uvi: Double?
    
    var plusMinusState:String {
        get {
            if let currentTemperature = currentTemperature {
                if currentTemperature < 0 {
                    return "-"
                } else {
                    return ""
                }
            }
            return ""
        }
    }
    
}
