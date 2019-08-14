//
//  AlphaviteControl.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 03/08/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

import UIKit

@IBDesignable
class AlpaviteControl: UIView {

    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    @IBInspectable var borderColor: UIColor? {
        get {
            return layer.borderColorFromUIcolor
        }
        set {
            layer.borderColorFromUIcolor = newValue
        }
    }
    var shadowLayer: CALayer!

    override func awakeFromNib() {
        super.awakeFromNib()

        clipsToBounds = true
        shadowLayer = addInnerShadow()
        layer.insertSublayer(shadowLayer, at: 0)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = 12
        let radius = CGFloat(12.0)
        let path = UIBezierPath(roundedRect: bounds.insetBy(dx: -1, dy:-1), cornerRadius:radius)
        let cutout = UIBezierPath(roundedRect: bounds, cornerRadius:radius).reversing()
        path.append(cutout)

        shadowLayer.shadowPath = path.cgPath
    }

    private func addInnerShadow() -> CALayer {
        let innerShadow = CALayer()
        innerShadow.frame = bounds

        // Shadow path (1pt ring around bounds)
        let radius = CGFloat(12.0)
        let path = UIBezierPath(roundedRect: innerShadow.bounds.insetBy(dx: -1, dy:-1), cornerRadius:radius)
        let cutout = UIBezierPath(roundedRect: innerShadow.bounds, cornerRadius:radius).reversing()
        path.append(cutout)

        innerShadow.shadowPath = path.cgPath
        innerShadow.masksToBounds = true
        // Shadow properties
        innerShadow.shadowColor = UIColor.black.cgColor
        innerShadow.shadowOffset = CGSize(width: 3, height: 3)
        innerShadow.shadowOpacity = 0.3
        innerShadow.shadowRadius = 3
        innerShadow.cornerRadius = radius
        return innerShadow
    }
}
