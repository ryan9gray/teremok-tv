//
//  CommonDisplayLogic.swift
//  gu
//
//  Created by Sergey Starukhin on 07.07.17.
//  Copyright © 2017 tt. All rights reserved.
//

import Foundation
import UIKit

protocol CommonDisplayLogic: ModalPresentable {
    
    var activityView: LottieHUD? { get set }
    
    func showPreloader()
    func hidePreloader()
    func presentError(_ error: Error, completion: (() -> Void)?)
    func present(errorString: String, completion: (() -> Void)?)
    func present(errorString: String, cancelTitle: String, completion: (() -> Void)?)
    func present(title: String, actions: [UIAlertAction], completion: (() -> Void)?)
    func present(title: String, text: String, actions: [UIAlertAction], completion: (() -> Void)?)
    func showAlert(text: String, destructiveButtonTitle: String, handler: ((Bool) -> Swift.Void)?)
}

extension CommonDisplayLogic where Self: UIViewController {
    
    func showPreloader() {
        self.view.alpha = 0
        activityView?.showHUD()
    }
    
    func hidePreloader() {
        self.view.alpha = 1
        activityView?.stopHUD()
    }

    func presentError(_ error: Error, completion: (() -> Void)? = nil) {
        hidePreloader()
        present(error: error, completion: completion)
    }
    
    func present(errorString: String, completion: (() -> Void)? = nil) {
        hidePreloader()
        present(string: errorString, completion: completion)
    }
    
    func present(errorString: String, cancelTitle: String, completion: (() -> Void)? = nil) {
        hidePreloader()
        present(string: errorString, cancelTitle: cancelTitle, completion: completion)
    }
    
    func present(title: String, actions: [UIAlertAction], completion: (() -> Void)?) {
        hidePreloader()
        presentAlert(with: "", message: title, actions: actions, completion: completion)
    }
    
    func present(title: String, text: String, actions: [UIAlertAction], completion: (() -> Void)?) {
        hidePreloader()
        presentAlert(with: title, message: text, actions: actions, completion: completion)
    }
    
    func showAlert(text: String, destructiveButtonTitle: String, handler: ((Bool) -> Void)?) {
        //
        let alert = UIAlertController.init(title: "", message: text, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction.init(title: destructiveButtonTitle, style: .destructive, handler: { (_) in
            //
            if let callback = handler {
                callback(true)
            }
        }))
        alert.addAction(UIAlertAction.init(title: "Отменить", style: .cancel, handler: { (_) in
            //
            if let callback = handler {
                callback(false)
            }
        }))
        present(alert, animated: true, completion: nil)
    }

}

extension CommonDisplayLogic where Self: UITableViewController {
    
    func showPreloader() {
        activityView?.showHUD()
        tableView.isScrollEnabled = false
    }
    
    func hidePreloader() {
        activityView?.stopHUD()
        tableView.isScrollEnabled = true
    }
}
