//
//  RoundedCorverView.swift
//  Teremok-TV
//
//  Created by Виктор Пузаков on 09.04.2020.
//  Copyright © 2020 xmedia. All rights reserved.
//

import UIKit

class RoundedCorverView: UIView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        roundCorners(corners: [.bottomLeft, .bottomRight], radius: 6.0)
    }
}
