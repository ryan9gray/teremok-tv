//
//  MonsterCollectionViewCell.swift
//  Teremok-TV
//
//  Created by Дмитрий Грищенко on 19/08/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

import UIKit
import AVFoundation

class MonsterCollectionViewCell: UICollectionViewCell {
    @IBOutlet private var backImage: UIImageView!
    @IBOutlet private var frontImage: UIImageView!

    var item: MonsterMaster.Monster!

    override func layoutSubviews() {
        super.layoutSubviews()

        backImage.layer.cornerRadius = 12
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
    
    func bounceAnimation(completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5)
            }, completion: {
                finished in
                UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.layer.transform = CATransform3DIdentity
                    }, completion: {
                        finished in
                        completion?()
                }
                )
            }
        )
    }
}
