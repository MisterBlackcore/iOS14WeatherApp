import UIKit

class TodayForecastInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var leftWeatherParamNameLabel: UILabel!
    @IBOutlet weak var leftWeatherParamDataLabel: UILabel!
    @IBOutlet weak var rightWeatherParamNameLabel: UILabel!
    @IBOutlet weak var rightWeatherParamDataLabel: UILabel!
    
    //MARK: - Flow Functions
    
    func configureCell(with data: CurrentCityWeatherDescription, at index: Int) {
        switch index {
        case 0:
            if let sunset = data.sunset, let sunrise = data.sunrise {
                setUpLabels(leftParamName: "SUNRISE", leftParamInfo: DateConverterManager.shared.returnDataWith(params: "HH:mm", from: sunrise), rightParamName: "SUNSET", rightParamInfo: DateConverterManager.shared.returnDataWith(params: "HH:mm", from: sunset), index: 1)
            }
        case 1:
            if let humidity = data.humidity, let pop = data.pop {
                setUpLabels(leftParamName: "POSSIBILITY OF RAIN", leftParamInfo: "\(Int(pop * 100)) %", rightParamName: "HUMIDITY", rightParamInfo: "\(humidity) %", index: 2)
            }
        case 2:
            if let windSpeed = data.windSpeed, let feelsLike = data.feels_like { 
                setUpLabels(leftParamName: "WIND", leftParamInfo: "\(String(windSpeed)) km/h", rightParamName: "FEELS LIKE", rightParamInfo: "\(Int(feelsLike))°", index: 2)
            }
        case 3:
            if let pressure = data.pressure { //osadki??
                setUpLabels(leftParamName: "osadki", leftParamInfo: "placeholder", rightParamName: "PRESSURE", rightParamInfo: "\(String(pressure)) hPa", index: 2)
            }
        case 4: 
            if let visibility = data.visibility, let ufIndex = data.uvi {
                setUpLabels(leftParamName: "VISIBILITY", leftParamInfo: "\(String(Double(visibility)/1000)) km", rightParamName: "UVI", rightParamInfo: String(ufIndex), index: 2)
            }
        default:
            return
        }
    }
    
    private func setUpLabels(leftParamName: String, leftParamInfo: String, rightParamName: String, rightParamInfo: String, index: Int) {
        leftWeatherParamNameLabel.text = leftParamName
        leftWeatherParamDataLabel.text = leftParamInfo
        rightWeatherParamNameLabel.text = rightParamName
        rightWeatherParamDataLabel.text = rightParamInfo
        addSubview(SeparatorManager.shared.setSeparatorLineFor(style: index, width: bounds.size.width))
    }
    
}
