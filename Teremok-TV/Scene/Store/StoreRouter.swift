//
//  StoreRouter.swift
//  Teremok-TV
//
//  Created by R9G on 04/12/2018.
//  Copyright (c) 2018 xmedia. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

@objc protocol StoreRoutingLogic {

    func navigateAfterPurchase()
}

protocol StoreDataPassing {
    var dataStore: StoreDataStore? { get }
}

class StoreRouter: NSObject, StoreRoutingLogic, StoreDataPassing, CommonRoutingLogic {
    weak var viewController: StoreViewController?
    var dataStore: StoreDataStore?
    var modalControllersQueue = Queue<UIViewController>()

    // MARK: Routing

    func navigateAfterPurchase() {
        let settings = SettingsViewController.instantiate(fromStoryboard: .main)
        settings.needShowPromoCode = true
        viewController?.masterRouter?.pushChild(settings)
    }
}