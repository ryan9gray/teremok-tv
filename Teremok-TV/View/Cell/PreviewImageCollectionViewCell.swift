//
//  PreviewImageCollectionViewCell.swift
//  Teremok-TV
//
//  Created by R9G on 06/09/2018.
//  Copyright © 2018 xmedia. All rights reserved.
//

import UIKit

class PreviewImageCollectionViewCell: UICollectionViewCell, ImageCellProtocol {
    
    var linktoLoad: String = "" {
        didSet {
            setImage()
        }
    }
    
    @IBOutlet var imageView: PreviewImage!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.clipsToBounds = true
    }
}
