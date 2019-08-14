//
//  TTImageView.swift
//  Teremok-TV
//
//  Created by R9G on 25/08/2018.
//  Copyright © 2018 xmedia. All rights reserved.
//

import UIKit

@IBDesignable
class TTImageView: UIImageView {

    // MARK: - Properties
    
    @IBInspectable public var borderColor: UIColor = UIColor.Button.yellowBase {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable public var borderWidth: CGFloat = 4 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    var cornerRadius: CGFloat {
        return bounds.height/2
    }
    
    @IBInspectable var pulseDelay: Double = 0.0
    
    @IBInspectable var popIn: Bool = true

    @IBInspectable var popInDelay: Double = 0.4
    
    // MARK: - Shadow
    
    @IBInspectable public var shadowOpacity: CGFloat = 0.2 {
        didSet {
            layer.shadowOpacity = Float(shadowOpacity)
        }
    }
    
    @IBInspectable public var shadowColor: UIColor = UIColor.clear {
        didSet {
            layer.shadowColor = shadowColor.cgColor
        }
    }
    
    @IBInspectable public var shadowRadius: CGFloat = 0 {
        didSet {
            layer.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable public var shadowOffsetY: CGFloat = 0 {
        didSet {
            layer.shadowOffset.height = shadowOffsetY
        }
    }
    
    // MARK: - FUNCTIONS
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.masksToBounds = true
        layer.cornerRadius = cornerRadius
        layer.borderColor = self.borderColor.cgColor
        layer.borderWidth = bounds.height * 0.09
    }

    override func awakeFromNib() {
        if pulseDelay > 0 {
            UIView.animate(withDuration: 1, delay: pulseDelay, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: [], animations: {
                self.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                self.transform = CGAffineTransform.identity
            }, completion: nil)
        }
        
        if popIn {
            transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            UIView.animate(withDuration: 0.8, delay: popInDelay, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .allowUserInteraction, animations: {
                self.transform = CGAffineTransform.identity
            }, completion: nil)
        }
    }

}

@IBDesignable
class PreviewImage: UIImageView {

    override func awakeFromNib() {
        //layer.cornerRadius = bounds.height * roundCoefficient
        clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = bounds.height * roundCoefficient
        
    }
    
    @IBInspectable var roundCoefficient: CGFloat = 0.12 {
        didSet {
            setNeedsLayout()
        }
    }
}
