import Foundation
import UIKit

extension UITableViewCell {
    
    //MARK: - Flow Functions
    
    func maskCell(fromTop margin: CGFloat) {
        layer.mask = visibilityMask(withLocation: margin/frame.size.height)
        layer.masksToBounds = true
    }
    
    private func visibilityMask(withLocation location: CGFloat) -> CAGradientLayer {
        let mask = CAGradientLayer()
        mask.frame = bounds
        mask.colors = [UIColor.white.withAlphaComponent(0).cgColor, UIColor.white.cgColor]
        let num = location as NSNumber
        mask.locations = [num, num]
        return mask
    }
}
