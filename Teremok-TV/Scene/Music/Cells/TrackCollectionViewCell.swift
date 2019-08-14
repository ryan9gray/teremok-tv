//
//  TrackCollectionViewCell.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 30/03/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

import UIKit

class TrackCollectionViewCell: UICollectionViewCell {
    @IBOutlet private var subtitleLabel: UILabel!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!

    func configurate(title: String, subtitle: String) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        isPlay(false)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    private func isPlay(_ bool: Bool) {
        imageView.image = bool ? #imageLiteral(resourceName: "icTrackPause") : #imageLiteral(resourceName: "icTrackPlay")
    }

    override var isSelected: Bool {
        didSet {
            isPlay(isSelected)
        }
    }
}
