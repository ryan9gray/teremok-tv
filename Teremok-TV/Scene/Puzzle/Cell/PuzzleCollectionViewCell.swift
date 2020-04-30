//
//  PuzzleCollectionViewCell.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 11.04.2020.
//  Copyright © 2020 xmedia. All rights reserved.
//

import UIKit

class PuzzleCollectionViewCell: UICollectionViewCell {

	@IBOutlet var imageView: PreviewImage!
	@IBOutlet var checkView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

	func setImage(_ image: UIImage?, done: Bool) {
		imageView.image = image
		checkView.isHidden = !done
	}

}
