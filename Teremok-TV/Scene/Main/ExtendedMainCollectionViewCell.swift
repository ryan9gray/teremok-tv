//
//  ExtendedMainCollectionViewCell.swift
//  Teremok-TV
//
//  Created by Виктор Пузаков on 10.04.2020.
//  Copyright © 2020 xmedia. All rights reserved.
//

import UIKit

protocol DidSelectRazdelAt {
    func goToRazdel(razdel: Int)
    func goToSerial(razdel: Int, title: String)
}

class ExtendedMainCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private var collectionView: UICollectionView!
    
    //TO DO: отрефакторить это
    var serials: [MainContent] = []
    var razdelNumber: Int = 0
    var delegate: DidSelectRazdelAt?
    var videosCell: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let cells = [RazdelCollectionViewCell.self, MoreSerialsCollectionViewCell.self, LoadingCollectionViewCell.self, VideoCollectionViewCell.self]
        collectionView.register(cells: cells)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

extension ExtendedMainCollectionViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if let serials = serials[indexPath.row] as? RazdelVCModel.SerialItem {
                delegate?.goToSerial(razdel: serials.id, title: serials.name)
            }
        } else {
            delegate?.goToRazdel(razdel: razdelNumber)
        }
    }
}

extension ExtendedMainCollectionViewCell: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return serials.count
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            if videosCell {
                let cell = collectionView.dequeueReusableCell(withCell: VideoCollectionViewCell.self, for: indexPath)
                if let serials = serials[indexPath.row] as? Serial.Item {
                    cell.configure(item: serials)
                }
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withCell: RazdelCollectionViewCell.self, for: indexPath)
                if let serials = serials[indexPath.row] as? RazdelVCModel.SerialItem {
                    cell.configure(item: serials)
                }
                return cell
            }
        } else {
            let cell = collectionView.dequeueReusableCell(withCell: MoreSerialsCollectionViewCell.self, for: indexPath)
            return cell
        }
    }
}
