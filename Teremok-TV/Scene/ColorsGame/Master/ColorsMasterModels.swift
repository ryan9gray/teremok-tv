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

    enum Colors: String, CaseIterable {
        case white = "white"
        case black = "black"

        case red = "red"
        case orange = "orange"
        case yellow = "yellow"
        case green = "green"
        case lightBlue = "lightBlue"
        case blue = "blue"
        case violet = "violet"

        case brown = "brown"

        var sound: String {
            switch self {
                case .red:
                    return "ColorsGame_color_1"
                case .blue:
                    return "ColorsGame_color_2"
                case .green:
                    return "ColorsGame_color_3"
                case .yellow:
                    return "ColorsGame_color_4"
                case .white:
                    return "ColorsGame_color_5"
                case .black:
                    return "ColorsGame_color_6"
                case .orange:
                    return "ColorsGame_color_7"
                case .lightBlue:
                    return "ColorsGame_color_8"
                case .violet:
                    return "ColorsGame_color_9"
                case .brown:
                    return "ColorsGame_color_10"
            }
        }
        var soundUrl: URL {
            URL(fileURLWithPath: Bundle.main.path(forResource: sound, ofType: "wav")!)
        }
    }

    static let DefaultColors: [Colors] = [
        Colors.yellow,
        Colors.green,
        Colors.white
    ]

    static let Pack: [Colors: [String]] = [
        Colors.red: ["ColorsGame_subject_1_1", "ColorsGame_subject_1_2", "ColorsGame_subject_1_3", "ColorsGame_subject_1_4"],
        Colors.blue: ["ColorsGame_subject_2_1", "ColorsGame_subject_2_2", "ColorsGame_subject_2_3", "ColorsGame_subject_2_4"],
        Colors.green: ["ColorsGame_subject_3_1", "ColorsGame_subject_3_2", "ColorsGame_subject_3_3", "ColorsGame_subject_3_4"],
        Colors.yellow: ["ColorsGame_subject_4_1", "ColorsGame_subject_4_2", "ColorsGame_subject_4_3", "ColorsGame_subject_4_4"],
        Colors.white: ["ColorsGame_subject_5_1", "ColorsGame_subject_5_2", "ColorsGame_subject_5_3", "ColorsGame_subject_5_4"],
        Colors.black: ["ColorsGame_subject_6_1", "ColorsGame_subject_6_2", "ColorsGame_subject_6_3", "ColorsGame_subject_6_4"],
        Colors.orange: ["ColorsGame_subject_7_1", "ColorsGame_subject_7_2", "ColorsGame_subject_7_3", "ColorsGame_subject_7_4"],
        Colors.lightBlue: ["ColorsGame_subject_8_1", "ColorsGame_subject_8_2", "ColorsGame_subject_8_3", "ColorsGame_subject_8_4"],
        Colors.violet: ["ColorsGame_subject_9_1", "ColorsGame_subject_9_2", "ColorsGame_subject_9_3", "ColorsGame_subject_9_4"],
        Colors.brown: ["ColorsGame_subject_10_1", "ColorsGame_subject_10_2", "ColorsGame_subject_10_3", "ColorsGame_subject_10_4"]
    ]
    
    enum EmotionalsSad: String, CaseIterable {
        case sadOne = "ColorsGame_sad_1"
        case sadTwo = "ColorsGame_sad_2"
        case sadThree = "ColorsGame_sad_3"
        case sadFour = "ColorsGame_sad_4"
        
        var url: URL {
            URL(fileURLWithPath: Bundle.main.path(forResource: rawValue, ofType: "mp3")!)
        }
    }
    
    enum EmotionalsHappy: String, CaseIterable {
        case happyOne = "ColorsGame_fun_1"
        case happyTwo = "ColorsGame_fun_2"
        case happyThree = "ColorsGame_fun_3"
        case happyFour = "ColorsGame_fun_4"
        case happyFive = "ColorsGame_fun_5"
        case happySix = "ColorsGame_fun_6"
        
        var url: URL {
            URL(fileURLWithPath: Bundle.main.path(forResource: rawValue, ofType: "mp3")!)
        }
    }
    
    enum RedAnimation: String {
        case main = "main_red"
        case happy = "happy_red_1"
        case happyTwo = "happy_red_2"
        case sad = "sad_red_1"
        case sadTwo = "sad_red_2"
    }
    enum GreenAnimation: String {
        case main = "main_green"
        case happy = "happy_green_1"
        case happyTwo = "happy_green_2"
        case sad = "sad_green_1"
        case sadTwo = "sad_green_2"
    }
    enum Sound: String {
        case main = "colorsGameMain"
    }
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
                    return [.white, .white]
                case .black:
                    return [.black, UIColor.black.withAlphaComponent(0.8)]
                case .lightBlue:
                    return [UIColor.ColorsGame.lightBlueOne, UIColor.ColorsGame.lightBlueTwo]
                case .violet:
                    return [UIColor.ColorsGame.violetOne, UIColor.ColorsGame.violetTwo]
                case .brown:
                    return [UIColor.ColorsGame.brownOne, UIColor.ColorsGame.brownTwo]
            }
        }
    }
}
