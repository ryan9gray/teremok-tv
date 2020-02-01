//
//  AbstractButton.swift
//  Teremok-TV
//
//  Created by R9G on 24/08/2018.
//  Copyright © 2018 xmedia. All rights reserved.
//


import UIKit
import Lottie

class TTAbstractMainButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setBackgroundImage(#imageLiteral(resourceName: "icCircle"), for: .normal)
        self.setBackgroundImage(#imageLiteral(resourceName: "icCircleActive"), for: .selected)
        
    }
    override var isHighlighted: Bool {
        didSet {
            let xScale : CGFloat = isHighlighted ? 1.025 : 1.0
            let yScale : CGFloat = isHighlighted ? 1.05 : 1.0
            UIView.animate(withDuration: 0.1) {
                let transformation = CGAffineTransform(scaleX: xScale, y: yScale)
                self.transform = transformation
            }
        }
    }
    
}

class OrangeButton: UIRoundedButtonWithGradientAndShadow {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.gradientColors = Style.Gradients.yellow.value
    }
}
class AnimatedAbstractButton: UIButton {
	var animationView: AnimationView?

	override init(frame: CGRect) {
		super.init(frame: frame)

		setupView()
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setupView()
	}

	override func awakeFromNib() {
		super.awakeFromNib()

	}

	private func setupView() {
		setAnimation(file: "Envelope")
		setBackgroundImage(#imageLiteral(resourceName: "icCircle"), for: .normal)
		setBackgroundImage(#imageLiteral(resourceName: "icCircleActive"), for: .selected)
	}

	private func setAnimation(file: String){
		guard animationView == nil else { return }
		animationView = AnimationView(name: file)
		guard let av = animationView else { return }
		av.frame = bounds
		av.autoresizingMask = [.flexibleHeight, .flexibleWidth]
		av.contentMode = .scaleAspectFit
		av.loopMode = .loop
		av.animationSpeed = 1.0
		av.isUserInteractionEnabled = false
		addSubview(av)
		av.play()
	}

	func play() {
		animationView?.play()
	}

	override var isHighlighted: Bool {
		didSet {
			let xScale : CGFloat = isHighlighted ? 1.025 : 1.0
			let yScale : CGFloat = isHighlighted ? 1.05 : 1.0
			UIView.animate(withDuration: 0.1) {
				let transformation = CGAffineTransform(scaleX: xScale, y: yScale)
				self.transform = transformation
			}
		}
	}
}
