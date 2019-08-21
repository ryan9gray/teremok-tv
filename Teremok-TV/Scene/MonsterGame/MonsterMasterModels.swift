//
//  MonsterMasterModels.swift
//  Teremok-TV
//
//  Created by Дмитрий Грищенко on 15/08/2019.
//  Copyright (c) 2019 xmedia. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

enum MonsterMaster {
    // MARK: Use cases
    
    struct Monster {
        var imageName = ""
        var matchId: Int
        var flipped = true
    }
    
    static let monsterNames = [
        "monster_1",
        "monster_2",
        "monster_3",
        "monster_4",
        "monster_5",
        "monster_6",
        "monster_7",
        "monster_8",
        "monster_9",
        "monster_10",
        "monster_11"
    ]
}