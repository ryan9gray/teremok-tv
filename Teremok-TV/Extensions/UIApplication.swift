

import UIKit

extension UIApplication {
    class func topViewController(_ base: UIViewController? = (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController) -> UIViewController? {

//        if let root = base as? MasterViewController {
//            return root
//        }
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        
        if let tab = base as? UITabBarController {
            let moreNavigationController = tab.moreNavigationController
            
            if let top = moreNavigationController.topViewController, top.view.window != nil {
                return topViewController(top)
            } else if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        return base
    }
    
    class func topCommonRouterLogicController(_ base: UIViewController? = (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController) -> ModalPresentable? {
        if let topViewController = topViewController() as? ModalPresentable {
            return topViewController
        }
        if let presentableController = base as? ModalPresentable {
            return presentableController
        }
        return nil
    }
    
}
