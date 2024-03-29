//
//  AnimalsStatisticPresenter.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 25/05/2019.
//  Copyright (c) 2019 xmedia. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol AnimalsStatisticPresentationLogic:  CommonPresentationLogic{
    func presentStats(response: AnimalsStatResponse)
}

class AnimalsStatisticPresenter: AnimalsStatisticPresentationLogic {
    weak var viewController: AnimalsStatisticDisplayLogic?
    var displayModule: CommonDisplayLogic? {
        return viewController
    }
    
    // MARK: Do something

    func presentStats(response: AnimalsStatResponse) {
        
        let stat = AnimalsStatistic.Statistic(
            easy: AnimalsStatistic.StatisticData(
                rightAnswers: response.easy?.rightAnswers ?? "Нет данных",
                percent: response.easy?.percent ?? "Нет данных",
                speed: response.easy?.speed ?? "Нет данных"
            ),
            hard: AnimalsStatistic.StatisticData(
                rightAnswers: response.hard?.rightAnswers ?? "Нет данных",
                percent: response.hard?.percent ?? "Нет данных",
                speed: response.hard?.speed ?? "Нет данных"
            )
        )
        viewController?.displayStat(item: stat)
    }
}
