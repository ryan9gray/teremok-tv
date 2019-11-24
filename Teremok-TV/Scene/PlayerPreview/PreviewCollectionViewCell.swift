//
//  PreviewCollectionViewCell.swift
//  Teremok-TV
//
//  Created by R9G on 06/09/2018.
//  Copyright © 2018 xmedia. All rights reserved.
//

import UIKit

class PreviewCollectionViewCell: PreviewImageCollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(link: String){
        self.linktoLoad = link
    }
    func configure(data: Data?) {
        guard let data = data, let image = UIImage(data: data) else { return }

        imageView.image = image
    }
}
