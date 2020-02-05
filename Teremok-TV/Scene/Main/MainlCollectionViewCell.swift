//
//  MainlCollectionViewCell.swift
//  Teremok-TV
//
//  Created by R9G on 02/09/2018.
//  Copyright © 2018 xmedia. All rights reserved.
//

import UIKit
import Lottie

class MainlCollectionViewCell: UICollectionViewCell, AnimateCellProtocol {
    var animationView: AnimationView?
    var rainbowView: AnimationView?

    @IBOutlet var containerAnimation: UIView!
    @IBOutlet private var titleLbl: UILabel!
    
    @IBOutlet private var cloudImageView: UIImageView!
    var linktoLoad: String = ""

	var source: AnimaionSource = .link

	enum AnimaionSource {
		case link
		case local
	}

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    func configurate(title: String, image: UIImage?, link: String) {
		source = .link
        titleLbl.text = title
        cloudImageView.image = image
        linktoLoad = link
    }
	func configurate(title: String, image: UIImage?, animation: String) {
		source = .local
		titleLbl.text = title
		cloudImageView.image = image
		linktoLoad = animation
	}
}
