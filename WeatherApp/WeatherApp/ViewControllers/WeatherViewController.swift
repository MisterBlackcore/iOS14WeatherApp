import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    @IBOutlet weak var currentCityWeatherDescriptionView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var plusMinusTemperatureLabel: UILabel!
    @IBOutlet weak var degreeKindLabel: UILabel!
    @IBOutlet weak var minAndMaxTemperatureForTodayLabel: UILabel!
    @IBOutlet weak var openWeatherSiteButton: UIButton!
    
    @IBOutlet weak var currentWeatherDescriptionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var degreeKindLabelCenterYConstraint: NSLayoutConstraint!
    @IBOutlet weak var currentTemperatureLabelCenterYConstraint: NSLayoutConstraint!
    @IBOutlet weak var weatherDescriptionLabelBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var plusMinusTemperatureLabelCenterYConstraint: NSLayoutConstraint!
    
    var dailyModels = UserDefaultsManager.shared.loadDailyModelsData()
    var hourlyModels = UserDefaultsManager.shared.loadHourlyModelsData()
    var cityWeatherDescription = UserDefaultsManager.shared.loadHCurrentWeatherModelData()
    
    var lastVelocityYSign = 0
    var tableViewHeaderHeight:CGFloat?
    
    var cityNameLabelY:CGFloat?
    var cityNameLabelYConstraint:NSLayoutConstraint?
    
    lazy var headerViewMaxHeight:CGFloat = self.view.frame.size.height*0.4
    lazy var headerViewMinHeight:CGFloat = self.view.frame.size.height*0.15
    
    lazy var currentTemperatureLabelLowerPoint:CGFloat = currentTemperatureLabel.frame.origin.y + currentTemperatureLabel.frame.size.height
    lazy var minAndMaxTemperatureForTodayLabelLowerPoint:CGFloat = minAndMaxTemperatureForTodayLabel.frame.origin.y + minAndMaxTemperatureForTodayLabel.frame.size.height
    lazy var degreeKindLabelLowerPoint:CGFloat = degreeKindLabel.frame.origin.y + degreeKindLabel.frame.size.height
    lazy var plusMinusTemperatureLabelLowerPoint:CGFloat = currentTemperatureLabel.frame.origin.y + currentTemperatureLabel.frame.size.height
    
    var currentLocation: CLLocation?
    let locationManager = CLLocationManager()
    
    //MARK: - Main Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let image = UIImage(named: "backgroundPlaceholder") {
            self.view.backgroundColor = UIColor(patternImage: image)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.separatorStyle = .none
        setUpConstraints()
        updateCurrentWeatherView(with: cityWeatherDescription)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        findLocation()
        NotificationCenter.default.addObserver(self, selector: #selector(updateViewControllerUI), name: UIApplication.willEnterForegroundNotification, object: UIApplication.shared)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - IBActions
    
    @IBAction func openWeatherSiteButtonIsPressed(_ sender: UIButton) {
        if let city = cityWeatherDescription.cityName {
            NetworkingManager.shared.openWeatherSiteInSafari(cityName: city)
        }
    }
    
    @IBAction func updateViewControllerUI() {
        findLocation()
        requestWeatherForLocation()
    }
    
    //MARK: - Flow Functions
    
    func findLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func getCityName(latitude: CLLocationDegrees,longtitude: CLLocationDegrees) {
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: latitude, longitude: longtitude)
        geoCoder.reverseGeocodeLocation(location, preferredLocale: Locale(identifier: "en_US")) { (placemarks, _) in
            placemarks?.forEach({ (placemark) in
                if let city = placemark.locality {
                    ModelContentService.shared.addCityNameToCityWeatherDescription(from: city)
                }
                if let country = placemark.country {
                    ModelContentService.shared.addCountryNameToCityWeatherDescription(from: country)
                }
            })
        }
    }
    
    func requestWeatherForLocation() {
        if let currentLocation = currentLocation {
            let longtitude = currentLocation.coordinate.longitude
            let latitude = currentLocation.coordinate.latitude
            getCityName(latitude: latitude, longtitude: longtitude)
            NetworkingManager.shared.getWeatherData(latitude: latitude, longtitude: longtitude) { (result) in
                self.dailyModels = result.daily
                DispatchQueue.main.async {
                    self.cityWeatherDescription = ModelContentService.shared.fillInWeatherTodayModelFromApiRequest(from: result)
                    self.hourlyModels = ModelContentService.shared.fillInHourlyWeatherModelsArray(with: Array(result.hourly.prefix(24)), and: self.dailyModels)
                    self.updateCurrentWeatherView(with: self.cityWeatherDescription)
                    self.dailyModels.remove(at: 0)
                    UserDefaultsManager.shared.save(dailyModels: self.dailyModels, hourlyModels: self.hourlyModels, currentWeatherModel: self.cityWeatherDescription)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func updateCurrentWeatherView(with data: CurrentCityWeatherDescription) {
        cityNameLabel.text = data.cityName
        if let currentTemperature = data.currentTemperature{
            if currentTemperature < 0 {
                currentTemperatureLabel.text = "\(currentTemperature*(-1))"
            } else {
                currentTemperatureLabel.text = "\(currentTemperature)"
            }
        }
        weatherDescriptionLabel.text = data.weatherDescription?.capitalized
        if let maxTemperature = data.maxTemperature, let minTemperature = data.minTemperature {
            minAndMaxTemperatureForTodayLabel.text  = "Max. \(maxTemperature)°, min. \(minTemperature)°"
        }
        plusMinusTemperatureLabel.text = data.plusMinusState
    }
    
    func setUpConstraints() {
        currentWeatherDescriptionViewHeightConstraint.constant = headerViewMaxHeight
        cityNameLabelY = cityNameLabel.frame.origin.y
        if let cityNameLabelY = cityNameLabelY {
            cityNameLabelYConstraint = NSLayoutConstraint(item: cityNameLabel, attribute: .top, relatedBy: .equal, toItem: currentCityWeatherDescriptionView, attribute: .top, multiplier: 1, constant: cityNameLabelY)
        }
        cityNameLabelYConstraint?.isActive = true
        plusMinusTemperatureLabel.topAnchor.constraint(equalTo: weatherDescriptionLabel.bottomAnchor, constant: 0).isActive = true
        currentTemperatureLabel.topAnchor.constraint(equalTo: weatherDescriptionLabel.bottomAnchor, constant: 0).isActive = true
        degreeKindLabel.topAnchor.constraint(equalTo: weatherDescriptionLabel.bottomAnchor, constant: 0).isActive = true
        plusMinusTemperatureLabelCenterYConstraint.isActive = false
        degreeKindLabelCenterYConstraint.isActive = false
        currentTemperatureLabelCenterYConstraint.isActive = false
        weatherDescriptionLabelBottomConstraint.isActive = false
    }
    
}
