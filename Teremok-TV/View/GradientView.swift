//
//  GradientButton.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 03/08/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

import UIKit

@IBDesignable
class GradientView: UIView {
    var gradientColors : [UIColor] = Styles.Gradients.yellow.value {
        didSet {
            layoutSubviews()
        }
    }
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    private var gradientLayer = CAGradientLayer()
    private var vertical: Bool = false

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.masksToBounds = true
        layer.cornerRadius = cornerRadius

        //fill view with gradient layer

        gradientLayer.frame = self.bounds

        //style and insert layer if not already inserted
        if gradientLayer.superlayer == nil {

            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = vertical ? CGPoint(x: 0, y: 1) : CGPoint(x: 1, y: 0)
            gradientLayer.colors = gradientColors.map { $0.cgColor }
            gradientLayer.locations = [0.0, 1.0]

            layer.insertSublayer(gradientLayer, at: 0)
        }
    }
}
