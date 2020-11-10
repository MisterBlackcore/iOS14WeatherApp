import Foundation
import UIKit

class SeparatorManager {
    
    let indent:CGFloat = 25
    
    static let shared = SeparatorManager()
    private init () {}
    
    //MARK: - Flow Functions
    
    func setSeparatorLineFor(style: Int,width: CGFloat) -> UIView {
        let line = UIView()
        line.backgroundColor = .lightGray
        switch style{
        case 1:
            line.frame = CGRect(x: 0, y: 0, width: width, height: 1)
            return line
        case 2:
            line.frame = CGRect(x: indent, y: 0, width: width - 2*indent, height: 1)
            return line
        default:
            return UIView()
        }
    }
    
}
