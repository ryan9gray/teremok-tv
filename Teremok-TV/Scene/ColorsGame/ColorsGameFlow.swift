//
//  ColorsGameFlow.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 08/09/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

import UIKit

class ColorsGameFlow  {
    weak var master: ColorsMasterViewController?

    init(master: ColorsMasterViewController) {
        self.master = master
        isHard = LocalStore.colorsIsHard
    }
    var game: Game!

    private var isHard: Bool = false

    func startFlow() {
        game = Game()
        randomRound()
    }

    private func randomRound() {
        
    }

    private func startChoice() {

    }

    private func nextRound() {
        
    }

    class Game {
        var currentChars = Set(AlphaviteMaster.Char.keys)
        var roundWords: [String] = []
        var words: [String: String] = [:]
        var round = 0

        var statistic: [AlphaviteMaster.Statistic] = []
    }
    deinit {
        print("Logger: ColorsFlow deinit")
    }
}
