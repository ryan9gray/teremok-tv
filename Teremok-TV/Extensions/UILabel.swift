//
//  UILabel.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 02/02/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//
import UIKit

extension UILabel {

    @IBInspectable var isShadowOnText: Bool {
        get {
            return self.isShadowOnText
        }
        set {
            if newValue {
                self.layer.shadowColor = UIColor.black.cgColor
                self.layer.shadowRadius = 2.0
                self.layer.shadowOpacity = 1.0
                self.layer.shadowOffset = CGSize(width: 2, height: 2)
                self.layer.masksToBounds = false
            }
        }
    }
}