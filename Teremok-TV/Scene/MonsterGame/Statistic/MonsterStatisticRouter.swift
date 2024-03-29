//
//  MonsterStatisticRouter.swift
//  Teremok-TV
//
//  Created by Дмитрий Грищенко on 03/09/2019.
//  Copyright (c) 2019 xmedia. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol MonsterStatisticRoutingLogic: CommonRoutingLogic {
    
}

protocol MonsterStatisticDataPassing {
    var dataStore: MonsterStatisticDataStore? { get }
}

class MonsterStatisticRouter: MonsterStatisticRoutingLogic, MonsterStatisticDataPassing {
    weak var viewController: MonsterStatisticViewController?
    var dataStore: MonsterStatisticDataStore?
    var modalControllersQueue = Queue<UIViewController>()
}
