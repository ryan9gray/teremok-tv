//
//  ExtendebleCollectionCell.swift
//  Teremok-TV
//
//  Created by Виктор Пузаков on 05.05.2020.
//  Copyright © 2020 xmedia. All rights reserved.
//

import UIKit

protocol ExtendebleCollectionCell {
    var serials: [MainContent] {get set}
    var razdelNumber: Int {get set}
    var videosCell: Bool {get set}
    
    func configureLayout()
    func minimumSpacingAnimation(duration: TimeInterval)
}

extension ExtendebleCollectionCell where Self: ExtendedMainCollectionViewCell {
    
    func configureLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        layout.itemSize = CGSize(width: self.frame.height * 1.75, height: self.frame.height)
        layout.minimumInteritemSpacing = 0.0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        layout.minimumLineSpacing = -self.frame.height * 1.75 + 10
        collectionView.collectionViewLayout = layout
    }
    
    func minimumSpacingAnimation(duration: TimeInterval = 0.0) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        
        layout.itemSize = CGSize(width: self.frame.height * 1.75, height: self.frame.height)
        layout.minimumInteritemSpacing = 0.0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        layout.minimumLineSpacing = 20.0
        UIView.animate(withDuration: duration, animations: { [weak self] in
            self?.collectionView.setCollectionViewLayout(layout, animated: true)
        }) { [weak self] (result) in
            self?.collectionView.contentOffset = CGPoint(x: 0.0, y: 0.0)
        }
    }
}
