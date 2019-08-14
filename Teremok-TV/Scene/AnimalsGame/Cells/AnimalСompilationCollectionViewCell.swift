//
//  AnimalСompilationCollectionViewCell.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 20/05/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

import UIKit

class AnimalСompilationCollectionViewCell: PreviewImageCollectionViewCell {

    @IBOutlet private var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        titleLabel.textColor = UIColor.View.Label.orange
    }

    func configuration(name: String, pack: Int, link: String) {
        titleLabel.text = name //"Подборка \(pack)"
        linktoLoad = link
    }
}
