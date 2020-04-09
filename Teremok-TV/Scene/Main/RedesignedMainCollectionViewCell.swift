//
//  RedesignedMainCollectionViewCell.swift
//  Teremok-TV
//
//  Created by Виктор Пузаков on 09.04.2020.
//  Copyright © 2020 xmedia. All rights reserved.
//

import UIKit

class RedesignedMainCollectionViewCell: UICollectionViewCell {
    @IBOutlet private var thirdImageView: PreviewImage!
    @IBOutlet private var secondImageView: PreviewImage!
    @IBOutlet private var mainImageView: PreviewImage!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var moreSerialImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(title: String){
        titleLabel.text = title
    }
    //TO DO: заменить на нужные картинки
    func gameRazdelConfigure() {
        titleLabel.text = "Алфавит, Мемориз и другие игры"
        mainImageView.image = UIImage(named: "gameIcon")
        secondImageView.image = UIImage(named: "ic-monsterGame")
        thirdImageView.image = UIImage(named: "ic-alphavite")
    }
}
