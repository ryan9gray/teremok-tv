//
//  MonsterGameCollectionViewLayout.swift
//  Teremok-TV
//
//  Created by Дмитрий Грищенко on 02/09/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

import UIKit

class MonsterGameCollectionViewLayout: UICollectionViewLayout {
    enum FieldSize: Int {
        case small = 6
        case medium = 12
        case large = 20
    }
    
    var itemSize: CGSize {
        get {
            switch numberOfItems {
            case .small:
                return CGSize(width: 150, height: 90)
            case .medium:
                return CGSize(width: 125, height: 75)
            case .large:
                return CGSize(width: 100, height: 60)
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

        numberOfItems = FieldSize(rawValue: collectionView.numberOfItems(inSection: 0)) ?? .small
        layoutAttributes.removeAll()
        
        for idx in 0..<numberOfItems.rawValue {
            let row = idx % numberOfRows
            let column = idx / numberOfRows
            var xPos = column * Int(itemSize.width + itemSpacing)
            let cellWidth = CGFloat(numberOfItems.rawValue / numberOfRows) * itemSize.width
            let spacingWidth = CGFloat((numberOfItems.rawValue / numberOfRows) - 1) * itemSpacing
            let xOffset = Int(collectionView.bounds.width - cellWidth - spacingWidth) / 2
            xPos += xOffset
            var yPos = row * Int(itemSize.height + itemSpacing)
            let yOffset = Int(collectionView.bounds.height - CGFloat(numberOfRows) * itemSize.height - CGFloat(numberOfRows - 1) * itemSpacing) / 2
            yPos += yOffset
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
