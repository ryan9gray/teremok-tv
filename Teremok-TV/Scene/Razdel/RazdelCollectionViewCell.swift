//
//  RazdelCollectionViewCell.swift
//  Teremok-TV
//
//  Created by R9G on 06/09/2018.
//  Copyright © 2018 xmedia. All rights reserved.
//

import UIKit
import AlamofireImage

final class RazdelCollectionViewCell: PreviewImageCollectionViewCell {

    @IBOutlet private var titleLbl: UILabel!
    @IBOutlet private var secondImageView: PreviewImage!
    
    weak var delegate: ButtonCellProtocol?
    var item: RazdelVCModel.SerialItem?
    private let imagesNames: [String] = ["ic-alphaviteBack", "AnimalsBack", "ic-monsterBack", "RazdelBgImages-1", "RazdelBgImages-2", "RazdelBgImages-3", "RazdelBgImages-4", "RazdelBgImages-5"]
    
//    @IBAction func burgerClick(_ sender: Any) {
//        delegate?.buttonClick(self)
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(item: RazdelVCModel.SerialItem){
        self.item = item
        self.titleLbl.text = item.name
        self.linktoLoad = item.imageUrl
        let randomImageName = imagesNames.randomElement()
        secondImageView.image = UIImage(named: randomImageName ?? "AnimalsBack")
    }
}
