import Foundation

class DateConverterManager {
    
    static let shared = DateConverterManager()
    private init () {}
    
    //MARK: - FlowFunctions
    
    func returnDataWith(params: String, from dt: Int) -> String {
        let unixTime = TimeInterval(dt)
        let stringTime = Date(timeIntervalSince1970: unixTime)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = params
        return dateFormatter.string(from: stringTime)
    }
}
