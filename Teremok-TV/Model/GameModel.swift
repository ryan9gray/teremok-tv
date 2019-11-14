//
//  GameModel.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 10/08/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

enum GameModel {
    enum Option: Int {
        case left = 0
        case right = 1

        var wrong: Int {
            switch self {
            case .left:
                return 1
            case .right:
                return 0
            }
        }
    }
}
