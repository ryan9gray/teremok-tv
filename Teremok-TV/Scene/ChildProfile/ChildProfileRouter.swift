//
//  ChildProfileRouter.swift
//  Teremok-TV
//
//  Created by R9G on 12/10/2018.
//  Copyright (c) 2018 xmedia. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ChildProfileRoutingLogic: CommonRoutingLogic {
    func navigateToPreview(number: Int)
    func reductProfile()
}

protocol ChildProfileDataPassing {
    var dataStore: ChildProfileDataStore? { get }
}

class ChildProfileRouter: NSObject, ChildProfileRoutingLogic, ChildProfileDataPassing {
    weak var viewController: ChildProfileViewController?
    var dataStore: ChildProfileDataStore?
    var modalControllersQueue = Queue<UIViewController>()

    // MARK: Routing
    func navigateToPreview(number: Int){
        let serials = PreviewViewController.instantiate(fromStoryboard: .play)
        guard var dataStore = serials.router?.dataStore else { return }
        guard let id = viewController?.router?.dataStore?.videoItems?[safe: number]?.id else {
            return
        }
        dataStore.model = .online(id: id)
        dataStore.razdId = 0
        viewController?.masterRouter?.presentNextChild(viewController: serials)
    }
    
    func reductProfile(){
        let addChild = ChildProfileAddViewController.instantiate(fromStoryboard: .autorization)
        guard var dataStore = addChild.router?.dataStore else { return }
        dataStore.screen = .Modify(viewController?.router?.dataStore?.child)
        //dataStore.child = viewController?.router?.dataStore?.child
        viewController?.masterRouter?.presentNextChild(viewController: addChild)
    }
}
