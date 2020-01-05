

import UIKit

extension UICollectionView {
    func dequeueReusableCell<T: UICollectionViewCell>(withCell cellType: T.Type, for indexPath: IndexPath) -> T {
        let identifier = cellType.cellIdentifier
        guard let cell = dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? T else {
            fatalError("\(identifier) isn't registered")
        }
        return cell
    }
    
    func register<T: UICollectionViewCell>(cells: [T.Type], fromBundle bundle: Bundle = Bundle.main) {
        for cell in cells {
            let identifier = String(describing: cell.cellIdentifier)
            if let _ = bundle.url(forResource: identifier, withExtension: "nib") {
                let nib = UINib(nibName: identifier, bundle: bundle)
                register(nib, forCellWithReuseIdentifier: identifier)
            } else {
                register(cell, forCellWithReuseIdentifier: identifier)
            }
        }
    }
    
    
}
extension UICollectionView {
    var centerPoint : CGPoint {
        get {
            return CGPoint(x: self.center.x + self.contentOffset.x, y: self.center.y + self.contentOffset.y);
        }
    }
    
    var centerCellIndexPath: IndexPath? {
        
        if let centerIndexPath = self.indexPathForItem(at: self.centerPoint) {
            return centerIndexPath
        }
        return nil
    }
}

extension UICollectionView {
    func scrollToIndexpathByShowingHeader(_ indexPath: IndexPath) {
        let sections = self.numberOfSections
        if indexPath.section <= sections {
            let attributes = self.layoutAttributesForSupplementaryElement(ofKind: UICollectionView.elementKindSectionHeader, at: indexPath)
            let topOfHeader = CGPoint(x: 0, y: attributes!.frame.origin.y - self.contentInset.top)
            self.setContentOffset(topOfHeader, animated:false)
        }
    }
}
