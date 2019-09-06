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
        UIView.transition(from: fromView!, to: toView!, duration: 1.0, options: options) { finished in
            self.flipped.toggle()
            completion?()
        }
    }
}
