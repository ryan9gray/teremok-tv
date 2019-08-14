//
//  CALayer.swift
//  vapteke
//
//  Created by R9G on 27.06.2018.
//  Copyright © 2018 550550. All rights reserved.
//

import QuartzCore
import UIKit

extension CALayer {
    var borderColorFromUIcolor: UIColor? {
        get {
            if let borderColor = borderColor {
                return UIColor(cgColor: borderColor)
            }
            return nil
        }
        set {
            borderColor = newValue?.cgColor
        }
    }
}
