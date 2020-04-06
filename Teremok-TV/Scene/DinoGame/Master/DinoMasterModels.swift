//
//  DinoMasterModels.swift
//  Teremok-TV
//
//  Created by Виктор Пузаков on 06.04.2020.
//  Copyright © 2020 xmedia. All rights reserved.
//

import UIKit

enum DinoMaster {
    // MARK: Use cases
    
    struct Dino {
        var imageName = ""
    }
    
    static let dinoNames = [
        "dino_1",
        "dino_2",
        "dino_3",
        "dino_4",
        "dino_5",
        "dino_6",
        "dino_7",
        "dino_8",
        "dino_9",
        "dino_10",
        "dino_11",
        "dino_12",
        "dino_13",
        "dino_14",
        "dino_15",
        "dino_16",
        "dino_17",
        "dino_18",
        "dino_19",
        "dino_20",
        "dino_21",
        "dino_22",
        "dino_23",
        "dino_24",
        "dino_25",
        "dino_26",
        "dino_27",
        "dino_28",
        "dino_29",
        "dino_30",
        "dino_31",
        "dino_32",
        "dino_33",
        "dino_34",
        "dino_35",
        "dino_36",
        "dino_37",
        "dino_38",
        "dino_39",
        "dino_40",
        "dino_41",
        "dino_42",
        "dino_43",
        "dino_44",
        "dino_45",
        "dino_46",
        "dino_47",
        "dino_48"
    ]
    //TO DO: change part of songs
    enum Sound: String {
        case main = "monsterPickMain"
        case button = "push_button_sound"
        case rightAnswer = "monsterRight"
        case wrongAnswer = "monsterWrong"
        case closeAll = "monsterCloseAll"
        case openCard = "monsterOpenCard"
        case closeCards = "monsterCloseCards"
        
        var url: URL {
            return URL(fileURLWithPath: Bundle.main.path(forResource: rawValue, ofType: "wav")!)
        }
        
    }
}
