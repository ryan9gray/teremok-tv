//
//  DinoFlow.swift
//  Teremok-TV
//
//  Created by Виктор Пузаков on 06.04.2020.
//  Copyright © 2020 xmedia. All rights reserved.
//

import UIKit

class DinoGameFlow {
    weak var master: DinoMasterViewController?
    private let service: MonsterServiceProtocol = MonsterService()

    init(master: DinoMasterViewController) {
        self.master = master
    }
    
    var game: Game!
    var checkIntro: Bool = true

    func startFlow(difficulty: Int) {
        if checkIntro, !LocalStore.monsterIntroduce {
            checkIntro = false
            showIntroduce(difficulty: difficulty)
            return
        }
        
        game = Game(gameDifficulty: Game.Difficulty(rawValue: difficulty) ?? .easy)
        randomRound()
    }
    
    private func randomRound() {
        randomizeDinos(length: game.difficulty.fieldSize)
        startGame()
    }
    
    private func randomizeDinos(length: Int) {
        game.items = [DinoMaster.Dino]()
        var dinoNames = DinoMaster.dinoNames
        for _ in 0..<length/2 {
            let name = dinoNames.randomElement()!
            let dino = DinoMaster.Dino(imageName: name)
            game.items.append(dino)
            game.items.append(dino)
            if let idx = dinoNames.firstIndex(of: name) {
                dinoNames.remove(at: idx)
            }
        }
        game.items.shuffle()
    }
    
    private func startGame() {
        if canPlay() {
            let controller = DinoGameViewController.instantiate(fromStoryboard: .dino)
            controller.input = DinoGameViewController.Input(game: game)
            controller.output = DinoGameViewController.Output(openResults: openResult)
            master?.router?.presentModalChild(viewController: controller)
        }
    }
    
    private func canPlay() -> Bool {
        if LocalStore.dinoFreeGames < 3 {
            LocalStore.dinoFreeGames += 1
            return true
        }
        else {
            guard Profile.current?.premiumGame ?? false else {
                self.buyAlert()
                return false
            }
            return true
        }
    }
    
    private func openResult(result: Int) {
        let gameResults = GameResults(result: result, gameWon: result > game.limit ? false : true)
        let controller = DinoGameResultsViewController.instantiate(fromStoryboard: .dino)
        controller.input = .init(gameResult: gameResults)
        controller.output = DinoGameResultsViewController.Output(openNext: {
            self.openNext(isWon: gameResults.gameWon)
        })
        master?.router?.presentModalChild(viewController: controller)
        service.sendStat(statistic: MonsterStatisticRequest(round: game.difficulty.rawValue, seconds: result)) { _ in }
    }
    
    private func openNext(isWon: Bool) {
        if isWon {
            randomRound()
        }
        else {
            startGame()
        }
    }
    
    private func showIntroduce(difficulty: Int) {
        let controller = IntroduceVideoViewController.instantiate(fromStoryboard: .common)
        controller.video = .monster
        master?.router?.introduceController(viewController: controller) { finish in
            LocalStore.monsterIntroduce = finish
            self.startFlow(difficulty: difficulty)
        }
    }
    
    private func buyAlert() {
        let vc = CloudAlertViewController.instantiate(fromStoryboard: .alerts)
        let text = Main.Messages.buyGames
        vc.model = AlertModel(title: "", subtitle: text, buttonTitle: "В настройки")
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        vc.complition = {
            self.master?.openSettings()
        }
        master?.presentAlertModally(alertController: vc)
    }
    
    deinit {
        print("Logger: GameFlow deinit")
    }
    
    class Game {
        enum Difficulty: Int {
            case easy = 0
            case medium = 1
            case hard = 2
            
            var fieldSize: Int {
                switch self {
                case .easy:
                    return 6
                case .medium:
                    return 12
                case .hard:
                    return 20
                }
            }

            var memTime: Double {
                switch self {
                case .easy:
                    return 1.0
                case .medium:
                    return 3.0
                case .hard:
                    return 4.0
                }
            }
        }
        
        init(gameDifficulty: Difficulty) {
            difficulty = gameDifficulty
        }
        
        let difficulty: Difficulty
        var items = [DinoMaster.Dino]()
        
        var limit: Int {
            get {
                switch difficulty {
                case .easy:
                    return 60
                case .medium:
                    return 180
                case .hard:
                    return 300
                }
            }
        }
    }
    
    struct GameResults {
        let result: Int
        let gameWon: Bool
    }
}
