//
//  KeyButton.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 01/08/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

import UIKit
import Spring

@IBDesignable
class KeyButton: UIButton {
    @IBInspectable var gradientColors : [UIColor] = Styles.Gradients.yellow.value {
        didSet {
            layoutSubviews()
        }
    }
    let startPoint: CGPoint = CGPoint(x: 0, y: 0)
    let endPoint: CGPoint = CGPoint(x: 1, y: 1)

    @IBInspectable var indent: CGFloat = 5

    @IBInspectable var backColor: UIColor = .clear

    @IBInspectable var isRound: Bool = false

    override func draw(_ rect: CGRect) {
        addShadow()
    }

    var shadowOpacity: Float = 0.2
    var shadowRadius: CGFloat = 10.0


    override func layoutSubviews() {
        super.layoutSubviews()

        layer.masksToBounds = false

        let gradient = CAGradientLayer()
        gradient.backgroundColor = backColor.cgColor
        gradient.frame = bounds
        gradient.colors = gradientColors.map { $0.cgColor }
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        gradient.cornerRadius = isRound ? gradient.frame.height / 2 : 12
        let secondGradient = CAGradientLayer()
        secondGradient.backgroundColor = backColor.cgColor
        secondGradient.frame = CGRect(x: indent, y: indent, width: bounds.width - indent*2, height: bounds.height - indent*2)
        secondGradient.colors = gradientColors.map { $0.cgColor }
        secondGradient.startPoint = endPoint
        secondGradient.endPoint = startPoint
        secondGradient.cornerRadius =  isRound ? secondGradient.frame.width / 2 : 10
        gradient.addSublayer(secondGradient)

        // replace gradient as needed
        if let oldGradient = layer.sublayers?[0] as? CAGradientLayer {
            layer.replaceSublayer(oldGradient, with: gradient)
        } else {
            layer.insertSublayer(gradient, below: nil)
        }
    }

    override var isHighlighted: Bool {
        didSet {
            let newOpacity : Float = isHighlighted ? 0.6 : shadowOpacity
            let newRadius : CGFloat = isHighlighted ? 6.0 : shadowRadius

            let shadowOpacityAnimation = CABasicAnimation()
            shadowOpacityAnimation.keyPath = "shadowOpacity"
            shadowOpacityAnimation.fromValue = layer.shadowOpacity
            shadowOpacityAnimation.toValue = newOpacity
            shadowOpacityAnimation.duration = 0.1

            let shadowRadiusAnimation = CABasicAnimation()
            shadowRadiusAnimation.keyPath = "shadowRadius"
            shadowRadiusAnimation.fromValue = layer.shadowRadius
            shadowRadiusAnimation.toValue = newRadius
            shadowRadiusAnimation.duration = 0.1

            layer.add(shadowOpacityAnimation, forKey: "shadowOpacity")
            layer.add(shadowRadiusAnimation, forKey: "shadowRadius")

            layer.shadowOpacity = newOpacity
            layer.shadowRadius = newRadius

            let xScale : CGFloat = isHighlighted ? 1.025 : 1.0
            let yScale : CGFloat = isHighlighted ? 1.05 : 1.0
            UIView.animate(withDuration: 0.1) {
                let transformation = CGAffineTransform(scaleX: xScale, y: yScale)
                self.transform = transformation
            }
        }
    }
}
