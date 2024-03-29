//
//  ChildProfileAddRouter.swift
//  Teremok-TV
//
//  Created by R9G on 30/08/2018.
//  Copyright (c) 2018 xmedia. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ChildProfileAddRoutingLogic: CommonRoutingLogic {
    func routToDoneProfile()
}

protocol ChildProfileAddDataPassing {
    var dataStore: ChildProfileAddDataStore? { get }
}

class ChildProfileAddRouter: NSObject, ChildProfileAddRoutingLogic, ChildProfileAddDataPassing {
    weak var viewController: ChildProfileAddViewController?
    var dataStore: ChildProfileAddDataStore?
    var modalControllersQueue = Queue<UIViewController>()

    // MARK: Routing

    func routToDoneProfile(){
        let vc = ChildProfileDoneViewController.instantiate(fromStoryboard: .autorization)
        guard var dataStore = vc.router?.dataStore else { return }
        dataStore.child = self.viewController?.router?.dataStore?.child
        dataStore.screen = self.viewController?.router?.dataStore?.screen
        viewController?.masterRouter?.presentNextChild(viewController: vc)
    }
}
