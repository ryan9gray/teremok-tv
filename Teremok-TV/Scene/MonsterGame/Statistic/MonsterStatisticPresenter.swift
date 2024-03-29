//
//  MonsterStatisticPresenter.swift
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

protocol MonsterStatisticPresentationLogic: CommonPresentationLogic {
    func presentStat(response: MonsterStatisticResponse)
}

class MonsterStatisticPresenter: MonsterStatisticPresentationLogic {
    
    weak var viewController: MonsterStatisticDisplayLogic?
    var displayModule: CommonDisplayLogic? {
        return viewController
    }
    
    func presentStat(response: MonsterStatisticResponse) {
        viewController?.showStats(MonsterStatisticViewController.Input(stat: response))
    }
}
