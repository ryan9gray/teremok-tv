//
//  DinoStatisticRouter.swift
//  Teremok-TV
//
//  Created by Виктор Пузаков on 06.04.2020.
//  Copyright © 2020 xmedia. All rights reserved.
//

import UIKit

protocol DinoStatisticRoutingLogic: CommonRoutingLogic {
    
}

protocol DinoStatisticDataPassing {
    var dataStore: DinoStatisticDataStore? { get }
}

class DinoStatisticRouter: DinoStatisticRoutingLogic, DinoStatisticDataPassing {
    weak var viewController: DinoStatisticViewController?
    var dataStore: DinoStatisticDataStore?
    var modalControllersQueue = Queue<UIViewController>()
}
