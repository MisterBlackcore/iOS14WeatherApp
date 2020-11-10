import Foundation
import UIKit
import CoreLocation

//MARK: - Extension - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    
    //MARK: - CLLocationManagerDelegate Functions
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty, currentLocation == nil {
            currentLocation = locations.first
            locationManager.stopUpdatingLocation()
            requestWeatherForLocation()
        }
    }
        
}
