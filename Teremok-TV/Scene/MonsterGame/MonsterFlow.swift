//
//  MonsterFlow.swift
//  Teremok-TV
//
//  Created by Дмитрий Грищенко on 19/08/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

import UIKit

class MonsterGameFlow {
    weak var master: MonsterMasterViewController?
    private let service: MonsterServiceProtocol = MonsterService()

    init(master: MonsterMasterViewController) {
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
        randomizeMonsters(length: game.difficulty.fieldSize)
        startGame()
    }
    
    private func randomizeMonsters(length: Int) {
        game.items = [MonsterMaster.Monster]()
        var monsterNames = MonsterMaster.monsterNames
        for _ in 0..<length/2 {
            let name = monsterNames.randomElement()!
            let monster = MonsterMaster.Monster(imageName: name)
            game.items.append(monster)
            game.items.append(monster)
            if let idx = monsterNames.firstIndex(of: name) {
                monsterNames.remove(at: idx)
            }
        }
        game.items.shuffle()
    }
    
    private func startGame() {
        if canPlay() {
            let controller = MonsterGameViewController.instantiate(fromStoryboard: .monster)
            controller.input = MonsterGameViewController.Input(game: game)
            controller.output = MonsterGameViewController.Output(openResults: openResult)
            master?.router?.presentModalChild(viewController: controller)
        }
    }
    
    private func canPlay() -> Bool {
        if LocalStore.monsterFreeGames < 3 {
            LocalStore.monsterFreeGames += 1
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
        let controller = MonsterGameResultsViewController.instantiate(fromStoryboard: .monster)
        controller.input = .init(gameResult: gameResults)
        controller.output = MonsterGameResultsViewController.Output(openNext: {
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
        var items = [MonsterMaster.Monster]()
        
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
