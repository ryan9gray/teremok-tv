//
//  FavCollectionViewCell.swift
//  Teremok-TV
//
//  Created by R9G on 27/10/2018.
//  Copyright © 2018 xmedia. All rights reserved.
//

import UIKit


protocol ButtonWithIndexPath: class {
    func clickOn(indexPath: IndexPath)
}

class FavCollectionViewCell: PreviewImageCollectionViewCell {
    var ip: IndexPath?
    weak var delegate: ButtonWithIndexPath?
    
    @IBAction func trashClick(_ sender: Any) {
        if let ip = self.ip {
            delegate?.clickOn(indexPath: ip)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(url: URL?) {
        guard let url = url else { return }
        linktoLoad = url.absoluteString
    }

    func configure(data: Data?) {
        guard let data = data, let image = UIImage(data: data) else { return }

        imageView.image = image
    }
}

