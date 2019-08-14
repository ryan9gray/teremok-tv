//
//  MainlCollectionViewCell.swift
//  Teremok-TV
//
//  Created by R9G on 02/09/2018.
//  Copyright © 2018 xmedia. All rights reserved.
//

import UIKit
import Lottie
import SpriteKit

class MainlCollectionViewCell: UICollectionViewCell, AnimateCellProtocol {
    
    var animationView: AnimationView?
    var rainbowView: AnimationView?

    @IBOutlet var containerAnimation: UIView!
    @IBOutlet private var titleLbl: UILabel!
    
    @IBOutlet private var cloudImageView: UIImageView!
    var linktoLoad: String = ""

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    func configurate(title: String, image: UIImage?, link: String) {
        titleLbl.text = title
        cloudImageView.image = image
        linktoLoad = link
    }
}
