import Foundation

struct HourlyWeatherModel: Codable {
    var time: Int?
    var possibilityOfRain: Double?
    var imageIconName: String?
    var tempOrSun: String?
}
