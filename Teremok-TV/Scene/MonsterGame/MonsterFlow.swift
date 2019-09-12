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
    
    init(master: MonsterMasterViewController) {
        self.master = master
    }
    
    var game: Game!
    var service: MonsterServiceProtocol!
    var gameResults: GameResults!
    
    func startFlow(difficulty: Int) {
        guard !LocalStore.monsterIntroduce() else {
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
        for idx in 0..<length/2 {
            let name = monsterNames.randomElement()!
            let monster = MonsterMaster.Monster(imageName: name, matchId: idx)
            game.items.append(monster)
            game.items.append(monster)
            if let idx = monsterNames.firstIndex(of: name) {
                monsterNames.remove(at: idx)
            }
        }
        game.items.shuffle()
    }
    
    private func startGame() {
        let controller = MonsterGameViewController.instantiate(fromStoryboard: .monster)
        controller.input = MonsterGameViewController.Input(game: game)
        controller.output = MonsterGameViewController.Output(openResults: openResult)
        master?.router?.presentModalChild(viewController: controller)
    }
    
    private func openResult(result: Int) {
        gameResults = GameResults(result: result, gameWon: result > game.limit ? false : true)
        let controller = MonsterGameResultsViewController.instantiate(fromStoryboard: .monster)
        controller.input = .init(gameResult: gameResults)
        controller.output = MonsterGameResultsViewController.Output(openNext: openNext)
        master?.router?.presentModalChild(viewController: controller)
        service.sendStat(statistic: MonsterStatisticRequest(round: game.difficulty.rawValue, seconds: result)) { _ in }
    }
    
    private func openNext() {
        if gameResults.gameWon {
            randomRound()
        }
        else {
            startGame()
        }
    }
    
    private func showIntroduce(difficulty: Int) {
        let controller = IntroduceVideoViewController.instantiate(fromStoryboard: .common)
        controller.video = .monster
        master?.router?.introduceController(viewController: controller) {
            self.startFlow(difficulty: difficulty)
        }
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
                get {
                    switch self {
                    case .easy:
                        return 6
                    case .medium:
                        return 12
                    case .hard:
                        return 20
                    }
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
