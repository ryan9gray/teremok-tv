//
//  MaintButton.swift
//  Teremok-TV
//
//  Created by R9G on 22.08.2018.
//  Copyright © 2018 xmedia. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class UIRoundedButtonWithGradientAndShadow: RoundEdgeButton {
    var gradientColors : [UIColor] = [] {
        didSet {
            layoutSubviews()
        }
    }
    let startPoint: CGPoint = CGPoint(x: 0, y: 0)
    let endPoint: CGPoint = CGPoint(x: 0, y: 1)
    
    @IBInspectable var backColor: UIColor = .clear
    
    override func draw(_ rect: CGRect) {
        addShadow()
    }

    var shadowOpacity: Float = 0.2 {
        didSet {
            //layer.shadowOpacity = Float(shadowOpacity)
        }
    }
    
    var shadowRadius: CGFloat = 10.0 {
        didSet {
            //layer.shadowRadius = shadowRadius
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()

        layer.masksToBounds = false

        // setup gradient
        
        let gradient = CAGradientLayer()
        gradient.backgroundColor = backColor.cgColor
        gradient.frame = bounds
        gradient.colors = gradientColors.map { $0.cgColor }
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        gradient.cornerRadius = layer.cornerRadius
        
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
