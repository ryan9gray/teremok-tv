//
//  AchieveCollectionViewCell.swift
//  Teremok-TV
//
//  Created by R9G on 27/09/2018.
//  Copyright © 2018 xmedia. All rights reserved.
//

import UIKit

class AchieveCollectionViewCell: PreviewImageCollectionViewCell {

    
    @IBOutlet private var titleLbl: UILabel!
    @IBOutlet private var subtitleLbl: UILabel!
    
    @IBOutlet private var progressBar: UIProgressView!
    @IBOutlet private var progressTitle: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(_ achieve: Achieves.Achievement){
        checkProgress(achieve)
        self.titleLbl.text = achieve.title
        self.subtitleLbl.text = achieve.subtitle
        self.linktoLoad = achieve.imageLink
    }
    func checkProgress(_ achieve: Achieves.Achievement){
        let progress = Float(achieve.progress)/Float(achieve.target)
        if  progress != 1 {
            progressBar.isHidden = false
            progressTitle.isHidden = false
            progressBar.progress = progress
            progressTitle.text = "\(achieve.progress)/\(achieve.target)"
        }
    }

}
