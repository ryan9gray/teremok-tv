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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thirdImageView.image = nil
        secondImageView.image = nil
        mainImageView.image = #imageLiteral(resourceName: "icNowifi")
        mainImageView.contentMode = .scaleAspectFit
        moreSerialImage.isHidden = false
    }

    func configure(title: String, topVideos: [Main.RazdelItemTop]){
        if topVideos.isEmpty {
            titleLabel.text = title
            return
        } else {
            titleLabel.text = topVideos[0].name
            if topVideos.count >= 1 {
                setImage(imageURL: topVideos[0].poster, imageView: mainImageView)
            }
            if topVideos.count >= 2 {
                setImage(imageURL: topVideos[1].poster, imageView: secondImageView)
            }
            if topVideos.count >= 3 {
                setImage(imageURL: topVideos[2].poster, imageView: thirdImageView)
            }
        }
    }
    
    //TO DO: заменить на нужные картинки
    func gameRazdelConfigure() {
        titleLabel.text = "Алфавит, Мемориз и другие игры"
        thirdImageView.image = UIImage(named: "gameIcon")
        secondImageView.image = UIImage(named: "gameIcon")
        mainImageView.image = UIImage(named: "gameIcon")
        mainImageView.contentMode = .scaleAspectFill
        moreSerialImage.isHidden = true
    }
    
    private func setImage(imageURL: String, imageView: UIImageView) {
        let downloadURL = URL(string: imageURL)!
        imageView.af_setImage(withURL: downloadURL,
                              placeholderImage: #imageLiteral(resourceName: "icNowifi"),
                              filter: nil,
                              imageTransition: .crossDissolve(0.5),
                              completion: nil)
        imageView.contentMode = .scaleAspectFill
    }
}
