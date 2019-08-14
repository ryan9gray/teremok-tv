//
//  AbstractButton.swift
//  Teremok-TV
//
//  Created by R9G on 24/08/2018.
//  Copyright © 2018 xmedia. All rights reserved.
//


import Foundation
import UIKit

class TTAbstractMainButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setBackgroundImage(#imageLiteral(resourceName: "icCircle"), for: .normal)
        self.setBackgroundImage(#imageLiteral(resourceName: "icCircleActive"), for: .selected)
        
    }
    override var isHighlighted: Bool {
        didSet {
            let xScale : CGFloat = isHighlighted ? 1.025 : 1.0
            let yScale : CGFloat = isHighlighted ? 1.05 : 1.0
            UIView.animate(withDuration: 0.1) {
                let transformation = CGAffineTransform(scaleX: xScale, y: yScale)
                self.transform = transformation
            }
        }
    }
    
}

class OrangeButton: UIRoundedButtonWithGradientAndShadow {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.gradientColors = Styles.Gradients.yellow.value
    }
}
