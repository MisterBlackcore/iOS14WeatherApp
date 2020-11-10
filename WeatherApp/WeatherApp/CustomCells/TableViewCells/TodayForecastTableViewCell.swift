import UIKit

class TodayForecastTableViewCell: UITableViewCell {
    
    @IBOutlet weak var todayForecastDescriptionLabel: UILabel!
    
    //MARK: - Main Functions
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        addSubview(SeparatorManager.shared.setSeparatorLineFor(style: 1, width: bounds.size.width))
    }
    
    //MARK: - Flow Functions
    
    func showTodayDescription(from data: CurrentCityWeatherDescription) {
        if let weatherDescription = data.weatherDescription, let currentTemperature = data.currentTemperature, let maxTemperature = data.maxTemperature {
            todayForecastDescriptionLabel.text = "Today: Now \(weatherDescription). Temperature is \(currentTemperature)°, expected maximum temperature for today is \(maxTemperature)°."
        }
    }
    
}
