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
    
    func configure(item: PreviewModel){
 
        self.linktoLoad = item.imageLink
    }
}
