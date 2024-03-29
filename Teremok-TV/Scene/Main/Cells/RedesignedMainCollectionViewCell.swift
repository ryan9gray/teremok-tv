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
    @IBOutlet private var moreSerialView: UIView!
    @IBOutlet private var serialLabel: UILabel!
    @IBOutlet private var serialNumberLabel: UILabel!
    
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
    }

    func configure(title: String, serialCount: Int,topVideos: [Main.RazdelItemTop]){
        serialNumberLabel.text = "+ " + String(serialCount)
        serialLabel.text = razdelsCountUniversal(serialCount)
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
    
    private func setImage(imageURL: String, imageView: UIImageView) {
        let downloadURL = URL(string: imageURL)!
        imageView.af_setImage(withURL: downloadURL,
                              placeholderImage: #imageLiteral(resourceName: "icNowifi"),
                              filter: nil,
                              imageTransition: .crossDissolve(0.5),
                              completion: nil)
        imageView.contentMode = .scaleAspectFill
    }
    
    private func razdelsCountUniversal(_ count: Int) -> String {
        let formatString: String = NSLocalizedString("Razdels count", comment: "")
        let resultString: String = String.localizedStringWithFormat(formatString, count)
        return resultString
    }
}
