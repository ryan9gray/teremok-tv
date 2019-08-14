//
//  SearchMusicCollectionViewCell.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 14/04/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

import UIKit

class SearchMusicCollectionViewCell: PreviewImageCollectionViewCell {
    @IBOutlet private var subtitleLabel: UILabel!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var durationLabel: UILabel!

    func configure(item: SearchMusic.Track) {
        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle
        durationLabel.text = item.duration
        linktoLoad = item.imageUrl
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override var isSelected: Bool {
        didSet {
            //isPlay(isSelected)
        }
    }
}
