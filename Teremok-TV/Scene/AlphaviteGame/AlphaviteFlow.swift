//
//  AlphaviteFlow.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 03/08/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

import UIKit

class AlphaviteGameFlow  {
    weak var master: AlphaviteMasterViewController?
    private let service: AlphabetServiceProtocol = AlphabetService()

    init(master: AlphaviteMasterViewController) {
        self.master = master
        isHard = LocalStore.alphaviteIsHard
    }

    private var isHard: Bool = false
    var game: Game!
    private var checkIntro: Bool = true

    func startFlow() {
        if checkIntro, !LocalStore.alphaviteIntroduce {
            checkIntro = false
            showIntroduce()
            return
        }

        game = Game()
        randomRound()
    }

    private func randomRound() {
        if game.round == 0, !(Profile.current?.premiumGame ?? false) {
            game.roundWords = AlphaviteMaster.DefaultChars
            AlphaviteMaster.DefaultChars.forEach { game.currentChars.remove($0) }
        } else {
            game.roundWords = []
            for _ in 0..<3 {
                let char = game.currentChars.randomElement()!
                game.roundWords.append(char)
                game.currentChars.remove(char)
            }
            guard !game.currentChars.isEmpty else {
                finishGame()
                return
            }
        }
        game.round += 1
        startTraining()
    }

    private func startTraining() {
        let controller = AlphaviteCharsViewController.instantiate(fromStoryboard: .alphavite)
        controller.input = AlphaviteCharsViewController.Input(chars: game.roundWords)
        controller.output = AlphaviteCharsViewController.Output(startChoice: startChoice)
        master?.router?.presentModalChild(viewController: controller)
    }

    private func startChoice() {
        let controller = AlphaviteChoiceViewController.instantiate(fromStoryboard: .alphavite)
        var words: [String : String] = [:]
        for char in game.roundWords {
            AlphaviteMaster.Words[char]?.forEach { words[$0] = char }
        }
        controller.input = AlphaviteChoiceViewController.Input(
            words: words,
            isHard: isHard
        )
        controller.output = AlphaviteChoiceViewController.Output(
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
        let controller = AlphaviteFinishViewController.instantiate(fromStoryboard: .alphavite)
        controller.input = AlphaviteFinishViewController.Input(answers: game.statistic.map { $0.isRight })
        controller.output = AlphaviteFinishViewController.Output(
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

    deinit {
        print("Logger: GameFlow deinit")
    }

    class Game {
        var currentChars = Set(AlphaviteMaster.Char.keys)
        var roundWords: [String] = []
        var words: [String: String] = [:]
        var round = 0

        var statistic: [AlphaviteMaster.Statistic] = []
    }
}
