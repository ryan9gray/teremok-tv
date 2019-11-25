

import UIKit

extension UITableViewCell {
    static var cellIdentifier: String {
        return String(describing: self)
    }
}
extension UICollectionViewCell {
    static var cellIdentifier: String {
        return String(describing: self)
    }
}
