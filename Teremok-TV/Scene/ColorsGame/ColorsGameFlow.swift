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
    private let service: ColorsGameServiceProtocol = ColorsGameService()

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
        if game.round == 0, !(Profile.current?.premiumGame ?? false) {
            game.roundColors = ColorsMaster.DefaultColors
            ColorsMaster.DefaultColors.forEach { game.currentColors.remove($0) }
        } else {
           game.roundColors = []
           for _ in 0..<3 {
               let char = game.currentColors.randomElement()!
               game.roundColors.append(char)
               game.currentColors.remove(char)
           }
           guard !game.currentColors.isEmpty else {
               finishGame()
               return
           }
        }
        game.round += 1
        startTraining()
    }

    private func startTraining() {

    }

    private func startChoice() {

    }


    private func nextRound() {
        
    }
    func finishGame() {
        master?.router?.popChild()
    }
    class Game {
        var currentColors = Set(ColorsMaster.Colors.allValues())
        var roundColors: [ColorsMaster.Colors] = []
        var colors: [ColorsMaster.Colors: String] = [:]
        var round = 0

        var statistic: [AlphaviteMaster.Statistic] = []
    }
    deinit {
        print("Logger: ColorsFlow deinit")
    }
}
