

import UIKit

enum UIToolbarInputAccessoryStyle {
    case done(UIResponder)
}

extension UIToolbar {
    static func inputAccessoryWith(style: UIToolbarInputAccessoryStyle) -> UIToolbar {
        let result = UIToolbar.init(frame: CGRect.init(x: 0.0, y: 0.0, width: 0.0, height: 44.0))
        result.isTranslucent = false
        result.tintColor = UIColor.white
        result.barTintColor = UIColor.View.yellowBase
        result.backgroundColor = UIColor.View.yellowBase
        
        switch style {
        case .done(let responder):
            result.items = [
                UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
                UIBarButtonItem.init(barButtonSystemItem: .done, target: responder, action: #selector(resignFirstResponder)),
                UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            ]
        }
        return result
    }
}
