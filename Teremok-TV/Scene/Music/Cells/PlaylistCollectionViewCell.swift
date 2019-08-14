//
//  PlaylistCollectionViewCell.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 17/03/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

import UIKit

class PlaylistCollectionViewCell: PreviewImageCollectionViewCell {

    @IBOutlet private var titleLbl: UILabel!
    var item: Album.Item?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(item: Album.Item) {
        self.item = item
        self.titleLbl.text = item.name
        self.linktoLoad = item.imageUrl
    }
}
