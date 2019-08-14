//
//  FavTableViewCell.swift
//  Teremok-TV
//
//  Created by R9G on 11/10/2018.
//  Copyright © 2018 xmedia. All rights reserved.
//

import UIKit

class FavTableViewCell: UITableViewCell {

    @IBOutlet private weak var collectionView: UICollectionView!
    
    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>(_ dataSourceDelegate: D, forRow row: Int) {
        
        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.tag = row
        collectionView.setContentOffset(collectionView.contentOffset, animated:false) // Stops collection view if it was scrolling.
        collectionView.reloadData()
    }
    
    var collectionViewOffset: CGFloat {
        set { collectionView.contentOffset.x = newValue }
        get { return collectionView.contentOffset.x }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let cells = [FavCollectionViewCell.self, LoadingCollectionViewCell.self]
        collectionView.register(cells: cells)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
