//
//  ColorsGameStatView.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 11.10.2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

import UIKit

class ColorsGameStatView: UIView {
    @IBOutlet private var gradientView: GradientView!
    @IBOutlet private var countLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        countLabel.textColor = UIColor.Alphavite.grey
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        gradientView.layer.masksToBounds = true
        gradientView.layer.borderWidth = 1.0
        gradientView.layer.borderColor = UIColor.white.cgColor

    }

    func set(color: ColorsMaster.Colors, count: String) {
        gradientView.gradientColors = color.value
        countLabel.text = count
    }
}
