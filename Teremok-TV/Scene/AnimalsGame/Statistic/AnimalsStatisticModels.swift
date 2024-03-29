//
//  AnimalsStatisticModels.swift
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

enum AnimalsStatistic {

    struct StatisticData {
        let rightAnswers: String
        let percent: String
        let speed: String
    }

    struct Statistic {
        let easy: StatisticData
        let hard: StatisticData
    }
}
