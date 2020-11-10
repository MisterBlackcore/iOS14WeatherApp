import Foundation

class ModelContentService {
    
    var cityWeatherDescriptionModel = CurrentCityWeatherDescription()
    var hourlyWeatherModels:[HourlyWeatherModel] = []
    
    static let shared = ModelContentService()
    private init () {}
    
    //MARK: - Flow Functions
    
    func addCityNameToCityWeatherDescription(from cityName: String) {
        cityWeatherDescriptionModel.cityName = cityName
    }
    
    func addCountryNameToCityWeatherDescription(from countryName: String) {
        cityWeatherDescriptionModel.countryName = countryName
    }
    
    func fillInWeatherTodayModelFromApiRequest(from data: WeatherData) -> CurrentCityWeatherDescription {
        cityWeatherDescriptionModel.weatherDescription = data.current.weather[0].description
        cityWeatherDescriptionModel.currentTemperature = Int(data.current.temp)
        cityWeatherDescriptionModel.maxTemperature = Int(data.daily[0].temp.max)
        cityWeatherDescriptionModel.minTemperature = Int(data.daily[0].temp.min)
        cityWeatherDescriptionModel.pop = data.daily[0].pop
        cityWeatherDescriptionModel.sunrise = data.current.sunrise
        cityWeatherDescriptionModel.sunset = data.current.sunset
        cityWeatherDescriptionModel.humidity = data.current.humidity
        cityWeatherDescriptionModel.windSpeed = data.current.wind_speed
        cityWeatherDescriptionModel.pressure = data.current.pressure
        cityWeatherDescriptionModel.visibility = data.current.visibility
        cityWeatherDescriptionModel.feels_like = data.current.feels_like
        cityWeatherDescriptionModel.uvi = data.current.uvi
        return cityWeatherDescriptionModel
    }
    
    func fillInHourlyWeatherModelsArray(with hourlyModels: [HourlyWeather], and dailyWeatherModels: [DailyWeather]) -> [HourlyWeatherModel] {
        hourlyWeatherModels = convertHourlyModels(from: hourlyModels)
        
        var sunsetAppended = false
        var sunriseAppnded = false
        
        var sunset = HourlyWeatherModel()
        var sunrise = HourlyWeatherModel()
        
        if dailyWeatherModels[0].sunset > hourlyModels[0].dt {
            sunset = fillInHourlyWeatherModel(time: dailyWeatherModels[0].sunset,
                                              possibilityOfRain: dailyWeatherModels[0].pop,
                                              imageIconName: "openWeatherMapIcon",
                                              tempOrTime: "Sunset")
            hourlyWeatherModels.append(sunset)
            sunsetAppended.toggle()
            if dailyWeatherModels[0].sunrise > hourlyModels[0].dt {
                sunrise = fillInHourlyWeatherModel(time: dailyWeatherModels[0].sunrise,
                                                  possibilityOfRain: dailyWeatherModels[0].pop,
                                                  imageIconName: "openWeatherMapIcon",
                                                  tempOrTime: "Sunrise")
                hourlyWeatherModels.append(sunrise)
                sunriseAppnded.toggle()
            }
        }
        
        if !sunsetAppended {
            sunset = fillInHourlyWeatherModel(time: dailyWeatherModels[1].sunset,
                                              possibilityOfRain: 0.0,
                                              imageIconName: "openWeatherMapIcon",
                                              tempOrTime: "Sunset")
            hourlyWeatherModels.append(sunset)
        }
        if !sunriseAppnded {
            sunrise = fillInHourlyWeatherModel(time: dailyWeatherModels[1].sunrise,
                                               possibilityOfRain: 0.0,
                                              imageIconName: "openWeatherMapIcon",
                                              tempOrTime: "Sunrise")
            hourlyWeatherModels.append(sunrise)
        }

        hourlyWeatherModels = hourlyWeatherModels.sorted(by: { $0.time! < $1.time! })
        return hourlyWeatherModels
    }
    
    private func convertHourlyModels(from models: [HourlyWeather]) -> [HourlyWeatherModel] {
        var modelsToReturn:[HourlyWeatherModel] = []
        for element in models {
            modelsToReturn.append(fillInHourlyWeatherModel(time: element.dt,
                                                           possibilityOfRain: element.pop,
                                                           imageIconName: element.weather[0].icon,
                                                           tempOrTime: "\(String(Int(element.temp)))°"))
        }
        return modelsToReturn
    }
    
    private func fillInHourlyWeatherModel(time: Int, possibilityOfRain: Double, imageIconName: String, tempOrTime: String) -> HourlyWeatherModel {
        var modelToReturn = HourlyWeatherModel()
        modelToReturn.time = time
        modelToReturn.possibilityOfRain = possibilityOfRain
        modelToReturn.imageIconName = imageIconName
        modelToReturn.tempOrSun = tempOrTime
        return modelToReturn
    }
    
}
