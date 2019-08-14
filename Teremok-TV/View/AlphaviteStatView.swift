//
//  AlphaviteStatView.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 10/08/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

import UIKit

class AlphaviteStatView: UIView {
    @IBOutlet private var charLabel: UILabel!
    @IBOutlet private var countLabel: UILabel!

    override func awakeFromNib() {
        charLabel.textColor = .white
        countLabel.textColor = UIColor.Alphavite.Button.grey

    }

    func set(char: String, count: String) {
        charLabel.text = char
        countLabel.text = count
    }
}
