//
//  AvatarCollectionViewCell.swift
//  Teremok-TV
//
//  Created by R9G on 23/09/2018.
//  Copyright © 2018 xmedia. All rights reserved.
//

import UIKit
import InfiniteScrolling
class AvatarCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var avatarImageView: TTImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

struct Avatar: InfiniteScollingData {
    
    let image: UIImage
    var isCamera: Bool
    
    init(image: UIImage, isCamera: Bool? = false) {
        self.image = image
        self.isCamera = isCamera ?? false
    }
    
    static let camera = Avatar(image: #imageLiteral(resourceName: "icPhoto"), isCamera: true)
    
    static let basicAvatars = [camera, Avatar(image: #imageLiteral(resourceName: "icTree")), Avatar(image: #imageLiteral(resourceName: "icDog")), Avatar(image: #imageLiteral(resourceName: "icUtka")), Avatar(image: #imageLiteral(resourceName: "icAvatarOne"))]
}
