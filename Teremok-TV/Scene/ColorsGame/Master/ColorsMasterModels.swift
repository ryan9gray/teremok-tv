//
//  ColorsMasterModels.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 08/09/2019.
//  Copyright (c) 2019 xmedia. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

enum ColorsMaster {

    enum Colors: String {
        case white = "white"
        case black = "black"

        case red = "red"
        case orange = "orange"
        case yellow = "yellow"
        case green = "green"
        case lightBlue = "lightBlue"
        case blue = "blue"
        case violet = "violet"

        var name: String {
            switch self {
                case .white:
                    return "Белый"
                case .black:
                    return "Черный"
                case .red:
                    return "Красный"
                case .orange:
                    return "Оранжевый"
                case .yellow:
                    return "Желтый"
                case .green:
                    return "Зеленый"
                case .lightBlue:
                    return "Голубой"
                case .blue:
                    return "Синий"
                case .violet:
                    return "Фиолетовый"
            }
        }
        var sound: String {
            switch self {
                case .white:
                    return ""
                case .black:
                    return ""
                case .red:
                    return ""
                case .orange:
                    return ""
                case .yellow:
                    return ""
                case .green:
                    return ""
                case .lightBlue:
                    return ""
                case .blue:
                    return ""
                case .violet:
                    return ""
            }
        }
    }

    static let DefaultColors: [Colors] = [
        Colors.yellow,
        Colors.green,
        Colors.white
    ]

    static let Pack: [Colors: [String]] = [
        Colors.white: ["animal_1", "animal_2"],
        Colors.black: ["animal_3", "animal_4"],
        Colors.red: ["animal_5", "animal_6"],
        Colors.orange: ["animal_7", "animal_8"],
        Colors.yellow: ["animal_9", "animal_10"],
        Colors.green: ["animal_11", "animal_12"],
        Colors.lightBlue: ["animal_13", "animal_14"],
        Colors.blue: ["animal_15", "animal_16"],
        Colors.violet: ["animal_17", "animal_18"]
    ]
}

extension ColorsMaster.Colors {
    var value: [UIColor] {
        get {
            switch self {
                case .yellow:
                    return [UIColor.ColorsGame.yellowOne, UIColor.ColorsGame.yellowTwo]
                case .orange:
                    return [UIColor.ColorsGame.orangeOne, UIColor.ColorsGame.orangeTwo]
                case .blue:
                    return [UIColor.ColorsGame.blueOne, UIColor.ColorsGame.blueTwo]
                case .red:
                    return [UIColor.ColorsGame.redOne, UIColor.ColorsGame.redTwo]
                case .green:
                    return [UIColor.ColorsGame.greenOne, UIColor.ColorsGame.greenTwo]
                case .white:
                    return [.white, .lightGray]
                case .black:
                    return [.black, UIColor.black.withAlphaComponent(0.8)]
                case .lightBlue:
                    return [UIColor.ColorsGame.lightBlueOne, UIColor.ColorsGame.lightBlueTwo]
                case .violet:
                    return [UIColor.ColorsGame.violetOne, UIColor.ColorsGame.violetTwo]
            }
        }
    }
}
