//
//  UIView.swift
//  Teremok-TV
//
//  Created by R9G on 22.08.2018.
//  Copyright © 2018 xmedia. All rights reserved.
//

import Foundation
import UIKit
typealias GradientPoints = (startPoint: CGPoint, endPoint: CGPoint)


extension UIView {
    enum GradientOrientation {
        case topRightBottomLeft
        case topLeftBottomRight
        case horizontal
        case vertical
        
        var startPoint : CGPoint {
            return points.startPoint
        }
        
        var endPoint : CGPoint {
            return points.endPoint
        }
        
        var points : GradientPoints {
            get {
                switch(self) {
                case .topRightBottomLeft:
                    return (CGPoint(x: 0.0,y: 1.0), CGPoint(x: 1.0,y: 0.0))
                case .topLeftBottomRight:
                    return (CGPoint(x: 0.0,y: 0.0), CGPoint(x: 1,y: 1))
                case .horizontal:
                    return (CGPoint(x: 0.0,y: 0.5), CGPoint(x: 1.0,y: 0.5))
                case .vertical:
                    return (CGPoint(x: 0.0,y: 0.0), CGPoint(x: 0.0,y: 1.0))
                }
            }
        }
    }
        
        func applyGradient(_ colours: [UIColor], locations: [NSNumber]? = nil) -> Void {
            let gradient = CAGradientLayer()
            gradient.frame = self.bounds
            gradient.colors = colours.map { $0.cgColor }
            gradient.locations = locations
            self.layer.insertSublayer(gradient, at: 0)
        }
        
        func applyGradient(_ colours: [UIColor], gradientOrientation orientation: GradientOrientation) -> Void {
            let gradient = CAGradientLayer()
            gradient.frame = self.bounds
            gradient.colors = colours.map { $0.cgColor }
            gradient.startPoint = orientation.startPoint
            gradient.endPoint = orientation.endPoint
            self.layer.insertSublayer(gradient, at: 0)
        }
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
