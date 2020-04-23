//
//  MainTitleView.swift
//  Teremok-TV
//
//  Created by Виктор Пузаков on 08.04.2020.
//  Copyright © 2020 xmedia. All rights reserved.
//

import UIKit

class MainTitleView: NibLoadableView {
    @IBOutlet private var titleBackgroundImage: UIImageView!
    @IBOutlet private var leftGarlandTrailingConstraint: NSLayoutConstraint!
    @IBOutlet private var rightGarlandLeadingConstraint: NSLayoutConstraint!
    @IBOutlet private var titleLabel: UILabel!
    
    private var title: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        leftGarlandTrailingConstraint.constant = garlandConstraintsCalculate()
        rightGarlandLeadingConstraint.constant = garlandConstraintsCalculate()
    }
    
    private func garlandConstraintsCalculate() -> CGFloat {
        return -titleBackgroundImage.frame.width * 0.13
    }
    
    func configureTitle(title: String) {
        if self.title != title {
            titleLabel.text = title
            configureAnimation()
            self.title = title
        }
    }
    
    private func configureAnimation() {
        
        let keyTimes: [NSNumber] = [0.0, 0.25, 0.5]
        let duration = 0.5
        let repeatCount: Float = 2.0
        
        let transformAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        transformAnimation.values = [1.0, 0.95, 1.0]
        transformAnimation.keyTimes = keyTimes
        transformAnimation.duration = duration
        transformAnimation.repeatCount = repeatCount
        titleBackgroundImage.layer.add(transformAnimation, forKey: "transformAnimation")
    }
}
