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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        leftGarlandTrailingConstraint.constant = garlandConstraintsCalculate()
        rightGarlandLeadingConstraint.constant = garlandConstraintsCalculate()
    }
    
    private func garlandConstraintsCalculate() -> CGFloat {
        return -titleBackgroundImage.frame.width * 0.13
    }
    
    func configureTitle(title: String) {
        titleLabel.text = title
    }
}
