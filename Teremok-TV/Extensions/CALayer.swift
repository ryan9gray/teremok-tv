
import QuartzCore
import UIKit

extension CALayer {
    var borderColorFromUIcolor: UIColor? {
        get {
            if let borderColor = borderColor {
                return UIColor(cgColor: borderColor)
            }
            return nil
        }
        set {
            borderColor = newValue?.cgColor
        }
    }
}
