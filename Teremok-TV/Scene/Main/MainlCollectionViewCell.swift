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
    
    var linktoLoad: String = ""

	var source: AnimaionSource = .link

	enum AnimaionSource {
		case link
		case local
	}

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    func configurate(link: String) {
		source = .link
        linktoLoad = link
    }
	func configurate(animation: String) {
		source = .local
		linktoLoad = animation
	}
}
