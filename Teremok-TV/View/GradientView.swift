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
    var gradientColors : [UIColor] = Style.Gradients.yellow.value {
        didSet {
            gradientLayer.colors = gradientColors.map { $0.cgColor }
            setNeedsLayout()
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
	var vector: GradientOrientation = .topLeftBottomRight

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.masksToBounds = true
        layer.cornerRadius = cornerRadius

        gradientLayer.frame = bounds

        //style and insert layer if not already inserted
        if gradientLayer.superlayer == nil {
            gradientLayer.startPoint = vector.startPoint
            gradientLayer.endPoint = vector.endPoint
            gradientLayer.colors = gradientColors.map { $0.cgColor }
			if gradientColors.count == 3 {
				gradientLayer.locations = [0.0, 0.5, 1.0]
			} else {
            	gradientLayer.locations = [0.0, 1.0]
			}
            layer.insertSublayer(gradientLayer, at: 0)
        }
    }

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
}
