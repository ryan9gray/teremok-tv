//
//  MonsterCollectionViewCell.swift
//  Teremok-TV
//
//  Created by Дмитрий Грищенко on 19/08/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

import UIKit

class MonsterCollectionViewCell: UICollectionViewCell {
    @IBOutlet private var backImage: UIImageView!
    @IBOutlet private var frontImage: UIImageView!

    var item: MonsterMaster.Monster!

    override func layoutSubviews() {
        super.layoutSubviews()

        frontImage.layer.cornerRadius = 12
    }
    
    func configuration(monster: MonsterMaster.Monster) {
        item = monster
        backImage.image = UIImage(named: "monsterCellCover")
        frontImage.image = UIImage(named: monster.imageName)
    }
    
    var flipped: Bool = true {
        didSet {
            frontImage.isHidden = !flipped
            backImage.isHidden = flipped
        }
    }

    func open(completion: (() -> Void)? = nil) {
        guard !flipped else { return }
        
        flipCard() {
            completion?()
        }
    }

    func close() {
        guard flipped else { return }

        flipCard()
    }
    
    func flipCard(completion: (() -> Void)? = nil) {
        let fromView = flipped ? frontImage : backImage
        let toView = flipped ? backImage : frontImage
        let flipDirection: UIView.AnimationOptions = flipped ? .transitionFlipFromRight : .transitionFlipFromLeft
        let options: UIView.AnimationOptions = [flipDirection, .showHideTransitionViews]
        UIView.transition(from: fromView!, to: toView!, duration: 0.7, options: options) { finished in
            self.flipped.toggle()
            completion?()
        }
    }

    func shakeAnimation(completion: (() -> Void)? = nil) {
        UIView.animateKeyframes(withDuration: 1.0, delay: 0, options: [], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
                let animation = CAKeyframeAnimation()
                animation.keyPath = "position.x"
                animation.values = [0, 10, -10, 10, -5, 5, -5, 0 ]
                animation.keyTimes = [0, 0.125, 0.25, 0.375, 0.5, 0.625, 0.75, 0.875, 1]
                animation.duration = 0.4
                animation.isAdditive = true
                self.layer.add(animation, forKey: "shake")
            })
        }, completion: { _ in
            completion?()
        })
    }
    func bounceAnimation(completion: (() -> Void)? = nil) {
        UIView.animateKeyframes(withDuration: 1.0, delay: 0, options: [], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
                let animation = CAKeyframeAnimation()
                animation.keyPath = "transform.scale"
                animation.values = [0, 0.2, -0.2, 0.2, 0]
                animation.keyTimes = [0, 0.2, 0.4, 0.6, 0.8, 1]
                animation.duration = 1.0
                animation.isAdditive = true
                self.layer.add(animation, forKey: "pop")
            })
        }, completion: { _ in
            completion?()
        })
    }
}
