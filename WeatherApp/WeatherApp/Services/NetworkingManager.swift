import Foundation
import UIKit
import CoreLocation

class NetworkingManager {
    
    static let shared = NetworkingManager()
    private init () {}
    
    //MARK: - Flow Functions
    
    func getWeatherData(latitude: CLLocationDegrees,longtitude: CLLocationDegrees,completion: @escaping (WeatherData) -> Void) {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longtitude)&exclude=minutely,alerts&units=metric&appid=61e8b2545b0e89b4dc5ef2625a5cf901") else {
            return
        }
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                var json: WeatherData?
                do {
                    json = try JSONDecoder().decode(WeatherData.self, from: data)
                } catch {
                    print("error: \(error)")
                }
                guard let result = json else {
                    return
                }
                completion(result)
            }
        }.resume()
    }
    
    func openWeatherSiteInSafari(cityName: String) {
        if let url = URL(string: "https://openweathermap.org/city/\(cityName)") {
            UIApplication.shared.open(url)
        }
    }
}
