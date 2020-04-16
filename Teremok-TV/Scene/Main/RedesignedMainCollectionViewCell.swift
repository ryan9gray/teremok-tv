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
    }

    func configure(title: String, imagesURLs: [String]){
        titleLabel.text = title
        //TO DO:
        if imagesURLs.count > 4 {
            print(imagesURLs[0])
            print(imagesURLs[1])
            print(imagesURLs[2])
            setImage(imageURL: imagesURLs[0], imageView: mainImageView)
            setImage(imageURL: imagesURLs[1], imageView: secondImageView)
            setImage(imageURL: imagesURLs[2], imageView: thirdImageView)
        }
        
    }
    
    //TO DO: заменить на нужные картинки
    func gameRazdelConfigure() {
        titleLabel.text = "Алфавит, Мемориз и другие игры"
        thirdImageView.image = UIImage(named: "gameIcon")
        secondImageView.image = UIImage(named: "gameIcon")
        mainImageView.image = UIImage(named: "gameIcon")
        mainImageView.contentMode = .scaleAspectFill
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
