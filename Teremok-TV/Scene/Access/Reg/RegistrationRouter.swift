//
//  RegistrationRouter.swift
//  Teremok-TV
//
//  Created by R9G on 10.08.2018.
//  Copyright (c) 2018 xmedia. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol RegistrationRoutingLogic: CommonRoutingLogic {
    func navigateToChild(email: String, pass: String)
    func routAuth()
}

protocol RegistrationDataPassing {
    var dataStore: RegistrationDataStore? { get }
}

class RegistrationRouter: NSObject, RegistrationRoutingLogic, RegistrationDataPassing {
    weak var viewController: RegistrationViewController?
    var dataStore: RegistrationDataStore?
    var modalControllersQueue = Queue<UIViewController>()
    
    // MARK: Routing
    func navigateToChild(email: String, pass: String){
        let vc = ChildProfileAddViewController.instantiate(fromStoryboard: .autorization)
        guard var dataStore = vc.router?.dataStore else { return }
        dataStore.screen = .Registrate
        dataStore.email = email
        dataStore.password = pass
        
        let agr = AgreementViewController.instantiate(fromStoryboard: .alerts)
        agr.modalPresentationStyle = .overCurrentContext
        agr.modalTransitionStyle = .crossDissolve
        agr.complition = { [weak self] in
            self?.viewController?.masterRouter?.presentNextChild(viewController: vc)
        }
        viewController?.present(agr, animated: true, completion: nil)
    }

    func routAuth() {
        let vc = AuthViewController.instantiate(fromStoryboard: .autorization)
        viewController?.masterRouter?.presentNextChild(viewController: vc)
    }
}