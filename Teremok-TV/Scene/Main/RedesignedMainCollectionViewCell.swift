//
//  RedesignedMainCollectionViewCell.swift
//  Teremok-TV
//
//  Created by Виктор Пузаков on 09.04.2020.
//  Copyright © 2020 xmedia. All rights reserved.
//

import UIKit

// TO DO
import Lottie

class RedesignedMainCollectionViewCell: UICollectionViewCell, RedesignedAnimateCellProtocol {
    var animationView: AnimationView?
    
    var linktoLoad: String = ""
    
    var source: AnimaionSource = .link

    enum AnimaionSource {
        case link
        case local
    }
    
    @IBOutlet private var thirdImageView: PreviewImage!
    @IBOutlet private var secondImageView: PreviewImage!
    @IBOutlet private var mainImageView: PreviewImage!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var moreSerialView: UIView!
    @IBOutlet private var serialLabel: UILabel!
    @IBOutlet private var serialNumberLabel: UILabel!
    @IBOutlet private var titleLabelTrailingConstratraintToMoreSerialImage: NSLayoutConstraint!
    @IBOutlet private var titleLabelTralingConstraintToSuperview: NSLayoutConstraint!
    
    @IBOutlet weak var containerAnimation: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        serialLabel.textColor = .white
        serialNumberLabel.textColor = .white
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thirdImageView.image = nil
        secondImageView.image = nil
        mainImageView.image = #imageLiteral(resourceName: "icNowifi")
        mainImageView.contentMode = .scaleAspectFit
        moreSerialView.isHidden = false
        serialLabel.text = "сериалов"
        serialNumberLabel.text = "+ 100"
        titleLabelTrailingConstratraintToMoreSerialImage.priority = UILayoutPriority(rawValue: 1000)
        titleLabelTralingConstraintToSuperview.priority = UILayoutPriority(rawValue: 750)
    }

    func configure(title: String, serialCount: Int,topVideos: [Main.RazdelItemTop]){
        serialNumberLabel.text = "+ " + String(serialCount)
        serialLabel.text = wordForCount(serialCount)
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
        moreSerialView.isHidden = true
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
    
    private func wordForCount(_ numeral: Int) -> String {
        let div100 = numeral % 100
        
        if div100 >= 11 && div100 <= 19 {
            return "сериалов"
        }
        
        let div10 = numeral % 10
        
        if div10 == 1 {
            return "сериал"
        } else if div10 >= 2 && div10 <= 4 {
            return "сериала"
        }
        return "сериалов"
    }
}
