//
//  MonsterGameCollectionViewLayout.swift
//  Teremok-TV
//
//  Created by Дмитрий Грищенко on 02/09/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

import UIKit

class MonsterGameCollectionViewLayout: UICollectionViewLayout {
    
    let xOffset: CGFloat = 50
    
    enum FieldSize: Int {
        case small = 6
        case medium = 12
        case large = 20
    }
    
    var itemSize: CGSize {
        get {
            guard let collectionView = collectionView else { return CGSize(width: 0, height: 0)}
            switch numberOfItems {
            case .small:
                return CGSize(width: (collectionView.bounds.width - (xOffset + itemSpacing * CGFloat(numberOfItems.rawValue / numberOfRows))) / CGFloat(numberOfItems.rawValue / numberOfRows), height: (collectionView.bounds.height - itemSpacing * CGFloat(numberOfRows)) / CGFloat(numberOfRows))
            case .medium, .large:
                return CGSize(width: (collectionView.bounds.width - (itemSpacing * CGFloat(numberOfItems.rawValue / numberOfRows))) / CGFloat(numberOfItems.rawValue / numberOfRows), height: (collectionView.bounds.height - itemSpacing * CGFloat(numberOfRows - 1)) / CGFloat(numberOfRows))
            }
        }
    }
    var itemSpacing: CGFloat {
        get {
            switch numberOfItems {
            case .small:
                return 25
            case .medium, .large:
                return 10
            }
        }
    }
    
    var layoutAttributes = [UICollectionViewLayoutAttributes]()
    
    private var numberOfItems = FieldSize.small
    var numberOfRows: Int {
        get {
            switch numberOfItems {
            case .small:
                return 2
            case .medium:
                return 3
            case .large:
                return 4
            }
        }
    }
    
    override func prepare() {
        guard let collectionView = collectionView else { return }
        numberOfItems = FieldSize.init(rawValue: collectionView.numberOfItems(inSection: 0)) ?? FieldSize.small
        layoutAttributes.removeAll()
        
        for idx in 0..<numberOfItems.rawValue {
            let row = idx % numberOfRows
            let column = idx / numberOfRows
            var xPos = column * Int(itemSize.width + itemSpacing)
            if numberOfItems == .small {
                xPos += 50
            }
            let yPos = row * Int(itemSize.height + itemSpacing)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(row: idx, section: 0))
            attributes.frame = CGRect(x: CGFloat(xPos), y: CGFloat(yPos), width: itemSize.width, height: itemSize.height)
            layoutAttributes.append(attributes)
        }
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return false
    }
    
    override var collectionViewContentSize: CGSize {
        guard let collectionView = collectionView else { return CGSize(width: 0, height: 0)}
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return layoutAttributes.filter {
            attributes in attributes.frame.intersects(rect)
        }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return layoutAttributes[indexPath.row]
    }
}
