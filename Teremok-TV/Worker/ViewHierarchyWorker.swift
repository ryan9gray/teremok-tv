//
//  ViewHierarchyWorker.swift
//  gu
//
//  Created by tikhonov on 08/06/2017.
//  Copyright © 2017 tt. All rights reserved.
//

import UIKit

struct ViewHierarchyWorker {
    
    static var mainWindow: UIWindow? {
        return (UIApplication.shared.delegate as? AppDelegate)?.window
    }
    
    static func setRootViewController(rootViewController: UIViewController, of window: UIWindow! = mainWindow) {
        guard let window = window else { print("window is nil"); return }
		UIView.transition(with: window, duration: 0.5, options: [.transitionCrossDissolve, .allowAnimatedContent], animations: {
			let oldState = UIView.areAnimationsEnabled
			UIView.setAnimationsEnabled(false)
			window.rootViewController = rootViewController
			UIView.setAnimationsEnabled(oldState)
		}, completion: nil)
    }
    
    static func resetAppForAuthentication(showExpirationAlert: Bool = false) {
        DispatchQueue.main.async {
  
            if let master = mainWindow?.rootViewController?.children.first as? MasterViewController {
                if master.router?.childVC is AuthViewController {
                    return
                }
                else {
                    master.router?.navigateToReg()
                }
            }
            //ViewHierarchyWorker.resetWindowHierarchyWithController(controller)
        }
    }
    
    static func resetWindowHierarchyWithController(_ controller: UIViewController) {
        if let windowRef = UIApplication.shared.delegate?.window, let window = windowRef {
            window.setRootViewController(controller)
        }
    }
}
