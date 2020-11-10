import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherConditionImageView: UIImageView!
    @IBOutlet weak var rainPossibilitylabel: UILabel!
    
    //MARK: - Flow Functions
    
    func configure(with model: HourlyWeatherModel, index: Int) {
        if index == 0 && (model.tempOrSun != "Sunset" || model.tempOrSun != "Sunrise") {
            timeLabel.text = "Now"
        } else if model.tempOrSun == "Sunset" || model.tempOrSun == "Sunrise"  {
            if let time = model.time {
                timeLabel.text = DateConverterManager.shared.returnDataWith(params: "HH:mm", from: time)
            }
        } else {
            if let time = model.time {
                timeLabel.text = DateConverterManager.shared.returnDataWith(params: "HH", from: time)
            }
        }
        if let possibilityOfRain = model.possibilityOfRain {
            if possibilityOfRain > 0 {
                rainPossibilitylabel.text = "\(Int(possibilityOfRain * 100)) %"
            }
        }
        if let tempOrSun = model.tempOrSun {
            temperatureLabel.text = tempOrSun
        }
        if let imageIconName = model.imageIconName {
            weatherConditionImageView.image = UIImage(named: imageIconName)
        }
    }
    
}
