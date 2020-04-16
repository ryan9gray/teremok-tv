//
//  VideoCollectionViewCell.swift
//  Teremok-TV
//
//  Created by R9G on 09/09/2018.
//  Copyright © 2018 xmedia. All rights reserved.
//

import UIKit

class VideoCollectionViewCell: PreviewImageCollectionViewCell {

    @IBOutlet private var titleLbl: UILabel!
    
    weak var delegate: SerialCellProtocol?
    var item: Serial.Item?
    @IBOutlet var heartBtn: TTAbstractMainButton!
    
    @IBOutlet var downloadBtn: TTAbstractMainButton!
    
    @IBAction func heartClick(_ sender: UIButton) {
        sender.isSelected.toggle()
        delegate?.favClick(self)
    }
    @IBAction func downClick(_ sender: UIButton) {
        //sender.isSelected.toggle()
        delegate?.downloadClick(self)
    }
    @IBAction func burgerClick(_ sender: UIButton) {
        delegate?.buttonClick(self)
    }
    
    func toLike(me: Bool){
        heartBtn.isSelected = me
    }
    func toDownload(me: Bool){
        downloadBtn.isSelected = me
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func configure(item: Serial.Item){
        self.item = item
        self.titleLbl.text = item.name
        toLike(me: item.isLikeMe)
        //TO DO: change color
        let image = item.isDownload ? UIImage(named:"icDownloadGray") : UIImage(named: "icDown")
        downloadBtn.setImage(image, for: .normal)
        toDownload(me: item.isDownload)
        self.linktoLoad = item.imageUrl
    }
}
