//
//  FavTableViewHeader.swift
//  Teremok-TV
//
//  Created by R9G on 11/10/2018.
//  Copyright © 2018 xmedia. All rights reserved.
//

import UIKit

class FavTableViewHeader: UITableViewHeaderFooterView {

    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    var labelInset: UIEdgeInsets! {
        didSet {
            labelTopConstraint.constant = labelInset.top
            labelLeadingConstraint.constant = labelInset.left
            labelTrailingConstraint.constant = labelInset.right
            labelBottomConstraint.constant = labelInset.bottom
        }
    }
    
    // MARK: - Private constraints
    @IBOutlet private var labelTopConstraint: NSLayoutConstraint!
    @IBOutlet private var labelLeadingConstraint: NSLayoutConstraint!
    @IBOutlet private var labelTrailingConstraint: NSLayoutConstraint!
    @IBOutlet private var labelBottomConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = .clear
        
        var inset = UIEdgeInsets.zero
        inset.top = labelTopConstraint.constant
        inset.left = labelLeadingConstraint.constant
        inset.right = labelTrailingConstraint.constant
        inset.bottom = labelBottomConstraint.constant
        labelInset = inset
    }
    
    func configure(image: UIImage, title: String){

        titleLabel.text = title
        self.imageView.image = image
        
        titleLabel.font = UIFont.defaultFont(ofSize: 20, for: .bold)

    }
}
