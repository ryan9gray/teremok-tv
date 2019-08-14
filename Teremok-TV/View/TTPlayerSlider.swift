//
//  TTPlayerSlider.swift
//  Teremok-TV
//
//  Created by R9G on 26/08/2018.
//  Copyright © 2018 xmedia. All rights reserved.
//

import UIKit

@IBDesignable
class TTPlayerSlider: UISlider {

    //open var progressView : UIProgressView

//    public override init(frame: CGRect) {
//        self.progressView = UIProgressView()
//        super.init(frame: frame)
//        configureSlider()
//
//    }
//    convenience init() {
//        self.init(frame: CGRect.zero)
//    }
//
//    required public init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }

    override func awakeFromNib() {
        super .awakeFromNib()
        //configureSlider()

    }
    override open func thumbRect(forBounds bounds: CGRect, trackRect rect: CGRect, value: Float) -> CGRect {
        let rect = super.thumbRect(forBounds: bounds, trackRect: rect, value: value)
        let newRect = CGRect(x: rect.origin.x, y: rect.origin.y + (thumbHeight * 0.5), width: rect.width, height: thumbHeight)
        return newRect
    }
    
    override open func trackRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.trackRect(forBounds: bounds)
        let newRect = CGRect(origin: rect.origin, size: CGSize(width: rect.size.width, height: trackHeight))
        //configureProgressView(newRect)
        return newRect
    }

    
    @IBInspectable var trackHeight: CGFloat = 10
    @IBInspectable var thumbHeight: CGFloat = 15

    @IBInspectable var thumbImage: UIImage? {
        didSet{
            setThumbImage(thumbImage, for: .normal)
        }
    }
    @IBInspectable var thumbImageHigh: UIImage? {
        didSet{
            setThumbImage(thumbImage, for: .highlighted)
        }
    }
}
