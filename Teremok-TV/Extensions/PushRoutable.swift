
import Foundation
import UIKit

protocol PushRoutable {
    @discardableResult func handle(push: TTPush) -> Bool
    func alertPresentedFor(push: TTPush)
}

extension PushRoutable where Self: UIViewController {
    
    func handle(push: TTPush) -> Bool {
        
        if let presentedViewController = presentedViewController as? PushRoutable, presentedViewController.handle(push: push) {
            return true
        }
        for childVC in children {
            
            if let childVC = childVC as? PushRoutable, childVC.handle(push: push) {
                return true
            }
        }
        return false
    }
    
    func alertPresentedFor(push: TTPush) {}
}

extension PushRoutable where Self: UINavigationController {
    
    var popViewControllerAnimatedWhenHandlePush: Bool {
        return true
    }
    
    func handle(push: TTPush) -> Bool {
        
        if let presentedViewController = presentedViewController as? PushRoutable, presentedViewController.handle(push: push) {
            return true
        }
        for childVC in viewControllers.reversed() {
            
            if let childVC = childVC as? PushRoutable, childVC.handle(push: push) {
                
                if let childVC = childVC as? UIViewController, childVC != topViewController {
                    topViewController?.presentedViewController?.dismiss(animated: true, completion: nil)
                    popToViewController(childVC, animated: popViewControllerAnimatedWhenHandlePush)
                }
                return true
            }
        }
        return false
    }
}

extension PushRoutable where Self: UITabBarController {
    
    func handle(push: TTPush) -> Bool {
        
        if let presentedViewController = presentedViewController as? PushRoutable, presentedViewController.handle(push: push) {
            return true
        }
        
        if let selectedViewController = selectedViewController as? PushRoutable, selectedViewController.handle(push: push) {
            return true
        }
        
        if let viewControllers = viewControllers {
            
            for (index, childVC) in viewControllers.enumerated() {
                if let childVC = childVC as? PushRoutable, childVC.handle(push: push) {
                    selectedIndex = index
                    return true
                }
            }
        }
        return false
    }
}
