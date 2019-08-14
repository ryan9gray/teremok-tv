//
//  GURoundEdgeButton.swift
//  gu
//
//  Created by Sergey Starukhin on 02.08.17.
//  Copyright © 2017 tt. All rights reserved.
//

import UIKit

@IBDesignable
class RoundEdgeButton: UIButton {

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
    
    @IBInspectable var roundCoefficient: CGFloat = 0.5 {
        didSet {
            setNeedsLayout()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height * roundCoefficient
    }
    
}
