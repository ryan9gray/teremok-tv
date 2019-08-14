//
//  CommonPresentationLogic.swift
//  gu
//
//  Created by Sergey Starukhin on 07.07.17.
//  Copyright © 2017 tt. All rights reserved.
//

import Foundation
import UIKit

protocol CommonPresentationLogic {
    
    var displayModule: CommonDisplayLogic? { get }
    
    func showPreloader()
    func hidePreloader()
    func presentError(error: Error, completion: (() -> Void)?)
    func present(errorString: String, completion: (() -> Void)?)
    func present(errorString: String, cancelTitle: String, completion: (() -> Void)?)
    func present(title: String, actions: [UIAlertAction], completion: (() -> Void)?)
    
    func presentCloud(errorString: String, subtitle: String, completion: (() -> Void)?)
    func presentCloud(errorString: String, subtitle: String, button: String, completion: (() -> Void)?)

    func presentScrolCloud(errorString: String, subtitle: String, completion: (() -> Void)?)

    func clearUserDataAndGoToAuthorization()
    func presentDestructiveAlert(text: String, destructiveButtonTitle: String, handler: ((Bool) -> Swift.Void)?)
}

extension CommonPresentationLogic {
    //
    func showPreloader() {
        displayModule?.showPreloader()
    }
    
    func hidePreloader() {
        displayModule?.hidePreloader()
    }
    func presentCloud(errorString: String, subtitle: String, completion: (() -> Void)?){
        displayModule?.presentCloud(title: errorString, subtitle: subtitle, completion: completion)
    }
    func presentCloud(errorString: String, subtitle: String, button: String, completion: (() -> Void)?){
        displayModule?.presentCloud(title: errorString, subtitle: subtitle, button: button, completion: completion)
    }
    func presentScrolCloud(errorString: String, subtitle: String, completion: (() -> Void)?){
        displayModule?.presentScrollCloud(title: errorString, subtitle: subtitle, completion: completion)
    }
    func presentError(error: Error, completion: (() -> Void)? = nil) {
        displayModule?.presentError(error, completion: completion)
    }
    
    func present(errorString: String, completion: (() -> Void)? = nil) {
        displayModule?.present(errorString: errorString, completion: completion)
    }
    
    func present(errorString: String, cancelTitle: String, completion: (() -> Void)? = nil) {
        displayModule?.present(errorString: errorString, cancelTitle: cancelTitle, completion: completion)
    }
    
    func present(title: String, actions: [UIAlertAction], completion: (() -> Void)?) {
        displayModule?.present(title: title, actions: actions, completion: completion)
    }
    
    func present(title: String, text: String, actions: [UIAlertAction], completion: (() -> Void)?) {
        displayModule?.present(title: title, text: text, actions: actions, completion: completion)
    }
    
    func clearUserDataAndGoToAuthorization() {
        hidePreloader()
        MainKeychainService().resetAuthentication()
        ViewHierarchyWorker.resetAppForAuthentication()
    }
    
    func presentDestructiveAlert(text: String, destructiveButtonTitle: String, handler: ((Bool) -> Swift.Void)? = nil) {
        displayModule?.showAlert(text: text, destructiveButtonTitle: destructiveButtonTitle, handler: handler)
    }
    

}
