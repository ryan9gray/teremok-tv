

import UIKit

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>(withCell cellType: T.Type, for indexPath: IndexPath) -> T {
        let identifier = cellType.cellIdentifier
        guard let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T else {
            fatalError("\(identifier) isn't registered")
        }
        return cell
    }
    
    func dequeueReusableCell<T: UITableViewCell>(withCell cellType: T.Type) -> T {
        let identifier = cellType.cellIdentifier        
        guard let cell = dequeueReusableCell(withIdentifier: identifier) as? T else {
            fatalError("\(identifier) isn't registered")
        }
        return cell
    }
    
    func register<T: UITableViewCell>(cells: [T.Type], fromBundle bundle: Bundle = Bundle.main) {
        for cell in cells {
            let identifier = String(describing: cell.cellIdentifier)
            if let _ = bundle.url(forResource: identifier, withExtension: "nib") {
                let nib = UINib(nibName: identifier, bundle: bundle)
                register(nib, forCellReuseIdentifier: identifier)
            } else {
                register(cell, forCellReuseIdentifier: identifier)
            }
        }
    }
    
    func register<T: UITableViewHeaderFooterView>(headerFooterView: T.Type) {
        let sectionIdentifier = String(describing: headerFooterView.self)
        let nib = UINib(nibName: sectionIdentifier, bundle: nil)
        register(nib, forHeaderFooterViewReuseIdentifier: sectionIdentifier)
    }
}
