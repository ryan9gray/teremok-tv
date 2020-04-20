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
    
    @IBOutlet weak var titleLabelTrailingConstratraintToMoreSerialImage: NSLayoutConstraint!
    @IBOutlet weak var titleLabelTralingConstraintToSuperview: NSLayoutConstraint!
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
        titleLabelTrailingConstratraintToMoreSerialImage.priority = UILayoutPriority(rawValue: 1000)
        titleLabelTralingConstraintToSuperview.priority = UILayoutPriority(rawValue: 750)
    }

    func configure(title: String, topVideos: [Main.RazdelItemTop]){
        if topVideos.isEmpty {
            titleLabel.text = title
            return
        } else {
            let topVideosCount = topVideos.count
            titleLabel.text = topVideos[0].name
            setImage(imageURL: topVideos[0].poster, imageView: mainImageView)
            if topVideosCount >= 2 {
                setImage(imageURL: topVideos[1].poster, imageView: secondImageView)
            }
            if topVideosCount >= 3 {
                setImage(imageURL: topVideos[2].poster, imageView: thirdImageView)
            }
        }
    }
    
    func gameRazdelConfigure() {
        titleLabel.text = "Алфавит, Мемориз и другие игры"
        thirdImageView.image = UIImage(named: "ic-alphaviteBack")
        secondImageView.image = UIImage(named: "ic-monsterBack")
        mainImageView.image = UIImage(named: "gameIcon")
        mainImageView.contentMode = .scaleAspectFill
        moreSerialImage.isHidden = true
        titleLabelTrailingConstratraintToMoreSerialImage.priority = UILayoutPriority(rawValue: 750)
        titleLabelTralingConstraintToSuperview.priority = UILayoutPriority(rawValue: 1000)
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
