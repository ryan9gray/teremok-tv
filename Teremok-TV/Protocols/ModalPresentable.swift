//
//  ModalPresentable.swift
//  vapteke
//
//  Created by R9G on 27.06.2018.
//  Copyright © 2018 550550. All rights reserved.
//


import Foundation
import UIKit

protocol ModalPresentable :AnyObject {
    var modallyControllerRoutingLogic: CommonRoutingLogic? { get }
    func displayAlertMessage(withTitle title: String, message: String, actions: [UIAlertAction])
    func presentAlert(with title: String, message: String, actions: [UIAlertAction], completion: (() -> Void)?)
    func present(string: String?, cancelTitle: String, completion: (() -> Void)?)
    func present(error: Error, cancelTitle: String, completion: (() -> Void)?)
    func presentAlert(with title: String, message: String, actions: [UIAlertAction])
    func presentAlert(with title: String?, message: String?, cancelTitle: String?)
    func presentCloud(title: String, subtitle: String, button: String, completion: (() -> Void)?)

    func presentCloud(title: String, subtitle: String, completion: (() -> Void)?)
    func presentScrollCloud(title: String, subtitle: String, completion: (() -> Void)?)

    func configureAlert(with title: String, message: String, actions: [UIAlertAction]) -> UIAlertController
}

extension ModalPresentable where Self: UIViewController {
    func displayAlertMessage(withTitle title: String, message: String, actions: [UIAlertAction]) {
        let alertController = configureAlert(with: title, message: message, actions: actions)
        presentAlertModally(alertController: alertController)
    }
    
    func presentCloud(title: String, subtitle: String, button: String, completion: (() -> Void)?){
        let vc = CloudAlertViewController.instantiate(fromStoryboard: .alerts)
        vc.model = AlertModel(title: title, subtitle: subtitle, buttonTitle: button)
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        vc.complition = completion
        presentAlertModally(alertController: vc)
    }
    func presentCloud(title: String, subtitle: String, completion: (() -> Void)?){
        let vc = CloudAlertViewController.instantiate(fromStoryboard: .alerts)
        vc.model = AlertModel(title: title, subtitle: subtitle)
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        vc.complition = completion
        presentAlertModally(alertController: vc)
    }
    func presentScrollCloud(title: String, subtitle: String, completion: (() -> Void)?){
        let vc = ScrollViewAlertViewController.instantiate(fromStoryboard: .alerts)
        vc.model = AlertModel(title: title, subtitle: subtitle)
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        vc.complition = completion
        presentAlertModally(alertController: vc)
    }
    
    func presentAlert(with title: String, message: String = "",
                      actions: [UIAlertAction] = [], completion: (() -> Void)? = nil) {
        let alertController = configureAlert(with: title, message: message, actions: actions)
        present(alertController, animated: true, completion: completion)
    }
    
    func present(string: String?, cancelTitle: String = "Закрыть", completion: (() -> Void)? = nil) {
        let okAction = UIAlertAction(title: cancelTitle, style: .default) { _ in
            completion?()
        }
        let alertController = configureAlert(with: "", message: string ?? "", actions: [okAction])
        presentAlertModally(alertController: alertController)
    }
    
    func present(error: Error, cancelTitle: String = "Закрыть", completion: (() -> Void)? = nil) {
        if let err = error as? URLError, err.code.rawValue == -1009 {
            return
        }
//        if case BackendError.unreachable = error {
//            NotificationCenter.default.post(name: .Internet, object: true, userInfo: nil)
//        }
        present(string: error.localizedDescription, cancelTitle: cancelTitle, completion: completion)
    }
    
    func presentAlert(with title: String, message: String = "", actions: [UIAlertAction] = []) {
        let alertController = configureAlert(with: title, message: message, actions: actions)
        presentAlertModally(alertController: alertController)
    }
    


    func presentAlert(with title: String? = nil, message: String? = nil, cancelTitle: String? = nil) {
        let okAction = UIAlertAction(title: cancelTitle ?? "Ok", style: .default, handler: nil)
        let alertController = configureAlert(with: title ?? "", message: message ?? "", actions: [okAction])
        presentAlertModally(alertController: alertController)
    }
    
    func configureAlert(with title: String, message: String = "", actions: [UIAlertAction] = []) -> UIAlertController {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        for action in actions {
            alertController.addAction(action)
        }
        alertController.applyStyle()
        return alertController
    }
    
    func presentAlertModally(alertController: UIViewController?) {
        modallyControllerRoutingLogic?.presentModallyNext(controller: alertController, from: self)
    }
}
