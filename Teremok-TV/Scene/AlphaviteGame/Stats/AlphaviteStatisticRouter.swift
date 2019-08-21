//
//  AlphaviteStatisticRouter.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 17/08/2019.
//  Copyright (c) 2019 xmedia. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol AlphaviteStatisticRoutingLogic: CommonRoutingLogic {
    
}

protocol AlphaviteStatisticDataPassing {
    var dataStore: AlphaviteStatisticDataStore? { get }
}

class AlphaviteStatisticRouter: AlphaviteStatisticRoutingLogic, AlphaviteStatisticDataPassing {
    weak var viewController: AlphaviteStatisticViewController?
    var dataStore: AlphaviteStatisticDataStore?
    var modalControllersQueue = Queue<UIViewController>()

    // MARK: Routing

}