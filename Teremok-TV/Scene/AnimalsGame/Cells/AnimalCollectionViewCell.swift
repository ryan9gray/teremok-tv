//
//  AnimalCollectionViewCell.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 26/05/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

import UIKit

class AnimalCollectionViewCell: UICollectionViewCell {
    @IBOutlet private var cloudImageView: UIImageView!
    @IBOutlet private var animalImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configurate(image: UIImage?) {
        animalImageView.image = image
    }
}
