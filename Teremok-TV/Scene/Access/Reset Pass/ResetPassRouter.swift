//
//  ResetPassRouter.swift
//  Teremok-TV
//
//  Created by R9G on 15/09/2018.
//  Copyright (c) 2018 xmedia. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ResetPassRoutingLogic: CommonRoutingLogic {
    func navigateToAuth()
    func pop()
}

protocol ResetPassDataPassing {
    var dataStore: ResetPassDataStore? { get }
}

class ResetPassRouter: NSObject, ResetPassRoutingLogic, ResetPassDataPassing {
    weak var viewController: ResetPassViewController?
    var dataStore: ResetPassDataStore?
    var modalControllersQueue = Queue<UIViewController>()

    // MARK: Routing


    func navigateToAuth(){
        viewController?.masterRouter?.navigateToAuth()
    }

    func pop(){
        viewController?.masterRouter?.popChild()
    }
}