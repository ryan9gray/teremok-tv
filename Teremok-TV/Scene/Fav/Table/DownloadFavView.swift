//
//  DownloadFavView.swift
//  Teremok-TV
//
//  Created by Eugene Ivanov on 19.11.2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

import UIKit

class DownloadFavView: UIView {
    @IBOutlet private var countLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = 15
    }

    func set(progress: String) {
        countLabel.text = progress
    }
}
