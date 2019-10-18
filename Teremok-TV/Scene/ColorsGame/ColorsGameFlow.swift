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
        let controller = ColorsTeachingViewController.instantiate(fromStoryboard: .colors)
        controller.input = ColorsTeachingViewController.Input(colors: game.roundColors)
        controller.output = ColorsTeachingViewController.Output(startChoice: startChoice)
        master?.router?.presentModalChild(viewController: controller)
    }

    private func startChoice() {
        let controller = ColorsChoiceViewController.instantiate(fromStoryboard: .colors)
        var words: [String : ColorsMaster.Colors] = [:]
        for color in game.roundColors {
            ColorsMaster.Pack[color]?.forEach { words[$0] = color }
        }
        controller.input = ColorsChoiceViewController.Input(
            colors: words,
            isHard: isHard
        )
        controller.output = ColorsChoiceViewController.Output(
            result: saveResult,
            nextChoice: finishRound
        )
        master?.router?.presentModalChild(viewController: controller)
    }


    private func nextRound() {
        if game.round == 1, !(Profile.current?.premiumGame ?? false) {
            buyAlert()
            return
        }
        randomRound()
    }

    func repeatRound() {
        startTraining()
    }

    private func saveResult(statistic: AlphaviteMaster.Statistic) {
        game.statistic.append(statistic)

    }

    private func finishRound() {
        let controller = ColorsFinishViewController.instantiate(fromStoryboard: .colors)
        controller.input = ColorsFinishViewController.Input(answers: game.statistic.map { $0.isRight })
        controller.output = ColorsFinishViewController.Output(
            nextChoice: nextRound,
            resume: repeatRound
        )
        master?.router?.presentModalChild(viewController: controller)
        service.sendStat(statistic: game.statistic.map { $0.maping() } ) { [weak self] _ in
            self?.game.statistic = []
        }
    }

    func finishGame() {
        master?.router?.popChild()
    }

    private func showIntroduce() {
        let controller = IntroduceVideoViewController.instantiate(fromStoryboard: .common)
        controller.video = .alphavite
        master?.router?.introduceController(viewController: controller, completion: { finish in
            LocalStore.alphaviteIntroduce = finish
            self.startFlow()
        })
    }

    private func authAlert() {
        master?.presentCloud(title: "", subtitle: Main.Messages.auth, button: "Зарегистрироваться") { [weak self] in
            self?.master?.openAutorization()
        }
    }

    private func buyAlert() {
        let vc = CloudAlertViewController.instantiate(fromStoryboard: .alerts)
        let text = Main.Messages.buyGames
        vc.model = AlertModel(title: "", subtitle: text, buttonTitle: "В настройки")
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        vc.complition = { [weak self] in
            self?.master?.openSettings()
        }
        master?.presentAlertModally(alertController: vc)
    }
    class Game {
        var currentColors = Set(ColorsMaster.Colors.allCases)
        var roundColors: [ColorsMaster.Colors] = []
        var colors: [ColorsMaster.Colors: String] = [:]
        var round = 0

        var statistic: [AlphaviteMaster.Statistic] = []
    }
    deinit {
        print("Logger: ColorsFlow deinit")
    }
}
