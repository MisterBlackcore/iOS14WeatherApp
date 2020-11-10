import UIKit

class WeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var maxTemperatureLabel: UILabel!
    @IBOutlet weak var minTemperatureLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var rainPossibilityLabel: UILabel!
    
    //MARK: - Flow Functions
    
    func configureCell(with model: DailyWeather) {
        minTemperatureLabel.text = "\(Int(model.temp.min))°" 
        maxTemperatureLabel.text = "\(Int(model.temp.max))°"
        if model.pop > 0 {
            rainPossibilityLabel.text = "\(Int(model.pop * 100)) %"
        }
        weatherIconImageView.image = UIImage(named: model.weather[0].icon)
        weatherIconImageView.contentMode = .scaleAspectFit
        dayLabel.text = DateConverterManager.shared.returnDataWith(params: "EEEE", from: model.dt)
    }
    
}
