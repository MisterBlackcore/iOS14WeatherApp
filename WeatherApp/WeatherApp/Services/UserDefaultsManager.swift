import Foundation

class UserDefaultsManager {
    
    let userDefaults = UserDefaults.standard
    
    static let shared = UserDefaultsManager()
    private init () {}
    
    //MARK: - Flow Functions
    
    func save(dailyModels: [DailyWeather], hourlyModels: [HourlyWeatherModel], currentWeatherModel: CurrentCityWeatherDescription) {
        saveDailyModels(dailyModels)
        saveHourlyModels(hourlyModels)
        saveCurrentWeatherModelFrom(currentWeatherModel)
    }
    
    private func saveCurrentWeatherModelFrom(_ currentWeather: CurrentCityWeatherDescription) {
        userDefaults.set(try? PropertyListEncoder().encode(currentWeather), forKey: "currentCityWeatherDescription")
    }
    
    private func saveDailyModels(_ dailyModels: [DailyWeather]) {
        userDefaults.set(try? PropertyListEncoder().encode(dailyModels), forKey: "dailyWeather")
    }
    
    //
    private func saveHourlyModels(_ hourlyModels: [HourlyWeatherModel]) {
        userDefaults.set(try? PropertyListEncoder().encode(hourlyModels), forKey: "hourlyWeatherModel")
    }
    
    func loadDailyModelsData() -> [DailyWeather] {
        if let data = userDefaults.value(forKey: "dailyWeather") as? Data {
            if let decodedDailyModels = try? PropertyListDecoder().decode(Array<DailyWeather>.self, from: data) {
                return decodedDailyModels
            }
        }
        return [DailyWeather]()
    }
    
    func loadHourlyModelsData() -> [HourlyWeatherModel] {
        if let data = userDefaults.value(forKey: "hourlyWeatherModel") as? Data {
            if let decodedHourlyModels = try? PropertyListDecoder().decode(Array<HourlyWeatherModel>.self, from: data) {
                return decodedHourlyModels
            }
        }
        return [HourlyWeatherModel]()
    }
    
    func loadHCurrentWeatherModelData() -> CurrentCityWeatherDescription {
        if let data = userDefaults.value(forKey: "currentCityWeatherDescription") as? Data {
            if let decodedCurrentWeatherModel = try? PropertyListDecoder().decode(CurrentCityWeatherDescription.self, from: data) {
                return decodedCurrentWeatherModel
            }
        }
        return CurrentCityWeatherDescription()
    }
    
}
