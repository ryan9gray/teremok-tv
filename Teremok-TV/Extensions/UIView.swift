

import Foundation
import UIKit
typealias GradientPoints = (startPoint: CGPoint, endPoint: CGPoint)


extension UIView {

    func addShadow(){
        layer.shadowColor = UIColor.Button.titleText.cgColor
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: layer.frame.height / 2).cgPath
        layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 10.0
    }
    func addTxtShadow(){
        layer.shadowColor = UIColor.View.titleText.cgColor
        layer.shadowRadius = 3.0
        layer.shadowOpacity = 1.0
        layer.shadowOffset = CGSize(width: 4, height: 4)
        layer.masksToBounds = false
    }    
}

public extension UIView {
    private static func loadNib<T: UIView>(
        name: String,
        bundle: Bundle,
        owner: Any?,
        options: [UINib.OptionsKey: Any]?
        ) -> T {
        guard let nibContent = bundle.loadNibNamed(name, owner: owner, options: options) else {
            fatalError("Cannot load nib with name \(name).")
        }

        guard let firstObject = nibContent.first else {
            fatalError("Cannot get first object from \(name) nib.")
        }

        guard let view = firstObject as? T else {
            fatalError("Invalid \(name) nib view type. Expected \(T.self), but received \(type(of: firstObject))")
        }

        return view
    }

    class func fromNib(
        name: String? = nil,
        bundle: Bundle? = nil,
        owner: Any? = nil,
        options: [UINib.OptionsKey: Any]? = nil
        ) -> Self {
        return loadNib(name: name ?? String(describing: self), bundle: bundle ?? Bundle(for: self), owner: owner, options: options)
    }
}
