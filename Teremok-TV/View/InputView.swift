//
//  InputView.swift
//  Teremok-TV
//
//  Created by R9G on 14/09/2018.
//  Copyright © 2018 xmedia. All rights reserved.
//

import Foundation
import UIKit

class CustomInputView: UIDatePicker, UIInputViewAudioFeedback {
    var intrinsicHeight: CGFloat = 200 {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        sizeToFit()
        autoresizingMask = UIView.AutoresizingMask.flexibleWidth
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: self.intrinsicHeight)
    }
}
