//
//  FavCollectionViewCell.swift
//  Teremok-TV
//
//  Created by R9G on 27/10/2018.
//  Copyright © 2018 xmedia. All rights reserved.
//

import UIKit


protocol ButtonWithIndexPath: class {
    func clickOn(indexPath: IndexPath)
}

class FavCollectionViewCell: PreviewImageCollectionViewCell {
    var ip: IndexPath?
    weak var delegate: ButtonWithIndexPath?
    @IBOutlet private var countLabel: UILabel!

    @IBAction func trashClick(_ sender: Any) {
        if let ip = self.ip {
            delegate?.clickOn(indexPath: ip)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        countLabel.isHidden = true
    }
    
    func configure(url: URL?) {
        guard let url = url else { return }
        linktoLoad = url.absoluteString
        imageView.alpha = 1
        NotificationCenter.default.removeObserver(self, name: .AssetDownloadProgress, object: nil)
    }

    func configure(data: Data?) {
        guard let data = data, let image = UIImage(data: data) else { return }
        imageView.alpha = 1
        imageView.image = image
        NotificationCenter.default.removeObserver(self, name: .AssetDownloadProgress, object: nil)
    }
    
    func configureProgress(data: Data?) {
        if let data = data, let image = UIImage(data: data) {
            imageView.image = image
        } else {
            imageView.backgroundColor = UIColor.Label.gray
        }
        imageView.alpha = 0.7
        countLabel.isHidden = false

        NotificationCenter.default.addObserver(self, selector: #selector(handleAssetDownloadProgress(_:)),
                                       name: .AssetDownloadProgress, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.done), name: .AssetDownloadStateChanged, object: nil)

    }

    @objc func handleAssetDownloadProgress(_ notification: NSNotification) {
        if let progress = notification.object as? Int {
            countLabel.text = progress.stringValue + "%"
        }
    }
    @objc func done(_ notification: NSNotification) {
        //countLabel.isHidden = true
        countLabel.text = ""
    }
}

