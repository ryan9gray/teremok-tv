//
//  DinoStatisticPresenter.swift
//  Teremok-TV
//
//  Created by Виктор Пузаков on 06.04.2020.
//  Copyright © 2020 xmedia. All rights reserved.
//

import UIKit

protocol DinoStatisticPresentationLogic: CommonPresentationLogic {
    func presentStat(response: DinoStatisticResponse)
}

class DinoStatisticPresenter: DinoStatisticPresentationLogic {
    
    weak var viewController: DinoStatisticDisplayLogic?
    var displayModule: CommonDisplayLogic? {
        return viewController
    }
    
    func presentStat(response: DinoStatisticResponse) {
        viewController?.showStats(DinoStatisticViewController.Input(stat: response))
    }
}
