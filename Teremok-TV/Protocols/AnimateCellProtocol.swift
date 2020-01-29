//
//  AnimateCellProtocol.swift
//  Teremok-TV
//
//  Created by R9G on 09/09/2018.
//  Copyright © 2018 xmedia. All rights reserved.
//

import UIKit
import Lottie

protocol AnimateCellProtocol {
    
    var animationView: AnimationView? { get set }
    var rainbowView: AnimationView? { get set }

    func setAnimation()
    func playAnimation()
    func pauseAnimation()
    var linktoLoad: String { get set }
    func setAnimation(file: String)
	var source: MainlCollectionViewCell.AnimaionSource { get set }
}

extension AnimateCellProtocol where Self: MainlCollectionViewCell {
    
    func setAnimation() {
        //guard animationView == nil else { return }
        if animationView != nil  {
            animationView?.removeFromSuperview()
            animationView = nil
        }
		let av: AnimationView
		switch source {
			case .link:
				guard linktoLoad != "", let url = URL(string: linktoLoad) else { return }
				av = AnimationView(url: url, closure: { _ in })
			case .local:
				av = AnimationView(name: linktoLoad)
		}

        animationView = av
        av.clipsToBounds = false
        av.frame = containerAnimation.bounds
        av.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        av.contentMode = .scaleAspectFit
        av.loopMode = .loop
        av.animationSpeed = 0.5
        containerAnimation.addSubview(av)
    }

    func setAnimation(file: String){
        guard animationView == nil else { return }
        animationView = AnimationView(name: file)
        guard let av = animationView else { return }
        //animationView = AnimationView.init(name: file)
        av.frame = containerAnimation.bounds
        av.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        av.contentMode = .scaleAspectFit
        av.loopMode = .loop
        av.animationSpeed = 0.5
        containerAnimation.addSubview(av)
    }
    func addRainbow(){
        guard rainbowView == nil else { return }

        rainbowView = AnimationView(name: "rainbow")
        guard let av = rainbowView else { return }
        av.frame = containerAnimation.bounds
        av.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        av.contentMode = .scaleAspectFill
        av.clipsToBounds = false

        av.loopMode = .playOnce
        av.animationSpeed = 0.5
        containerAnimation.addSubview(av)
        containerAnimation.addSubview(av)
        
    }
    
    func playRainbow(){
        rainbowView?.play()
    }
    func playAnimation(){
        animationView?.play()
    }
    func pauseAnimation(){
        animationView?.pause()
    }
}
