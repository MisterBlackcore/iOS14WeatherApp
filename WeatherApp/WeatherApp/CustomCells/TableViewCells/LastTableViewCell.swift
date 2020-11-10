import UIKit
import MapKit

class LastTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cityCountryLabel: UILabel!
    @IBOutlet weak var openMapButton: UIButton!
    
    var currentLocation: CLLocation?
    
    //MARK: - Main Functions
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        addSubview(SeparatorManager.shared.setSeparatorLineFor(style: 1, width: bounds.size.width))
    }
    
    //MARK: - IBActions
    
    @IBAction func openMapButtonIsPressed(_ sender: UIButton) {
        guard let currentLocation = currentLocation else {
            return
        }
        let regionDistance:CLLocationDistance = 100
        let coordinates = CLLocationCoordinate2DMake(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let options = [MKLaunchOptionsMapCenterKey:NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey:NSValue(mkCoordinateSpan: regionSpan.span)]
        let placemark = MKPlacemark(coordinate: coordinates)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.openInMaps(launchOptions: options)
    }
    
    //MARK: - Flow Functions
    
    func configureCell(with data: CurrentCityWeatherDescription) {
        if let city = data.cityName, let country = data.countryName {
            cityCountryLabel.text = "Weather - \(city), \(country) "
        }
    }
    
    func getCurrentLocation(from coordinates: CLLocation) {
        currentLocation = coordinates
    }
}
