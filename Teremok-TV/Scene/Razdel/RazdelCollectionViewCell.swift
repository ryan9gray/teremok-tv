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
    
    @IBOutlet var cloudImageView: UIImageView!
    
    weak var delegate: ButtonCellProtocol?
    var item: RazdelVCModel.SerialItem?
    
    @IBAction func burgerClick(_ sender: Any) {
        delegate?.buttonClick(self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(item: RazdelVCModel.SerialItem){
        self.item = item
        self.titleLbl.text = item.name
        self.linktoLoad = item.imageUrl
    }
}
