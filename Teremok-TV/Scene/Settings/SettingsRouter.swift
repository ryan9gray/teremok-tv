//
//  SettingsRouter.swift
//  Teremok-TV
//
//  Created by R9G on 22.08.2018.
//  Copyright (c) 2018 xmedia. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol SettingsRoutingLogic: CommonRoutingLogic  {
    func routToRegistration()
    func routToAuthorization()
    func routToChild(_ child: Child)
    func navigareToStore()
}

protocol SettingsDataPassing {
    var dataStore: SettingsDataStore? { get }
}

class SettingsRouter: NSObject, SettingsRoutingLogic, SettingsDataPassing, CommonRoutingLogic {
    weak var viewController: SettingsViewController?
    var dataStore: SettingsDataStore?
  
    var modalControllersQueue = Queue<UIViewController>()

    // MARK: Routing
    func routToChild(_ child: Child){
        viewController?.masterRouter?.pushChild(viewControllerClass: ChildsViewController.self, storyboard: .profile)

    }
    func routToRegistration(){
        let vc = RegistrationViewController.instantiate(fromStoryboard: .autorization)
        viewController?.masterRouter?.presentNextChild(viewController: vc)
    }
    func routToAuthorization(){
        let vc = AuthViewController.instantiate(fromStoryboard: .autorization)
        viewController?.masterRouter?.presentNextChild(viewController: vc)
    }
    
    func navigareToStore(){
        let vc = StoreViewController.instantiate(fromStoryboard: .main)
        viewController?.masterRouter?.pushChild(vc)
    }
    

}
