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
    var gameResults: GameResults!
    
    func startFlow(difficulty: Int) {
        guard !LocalStore.monsterIntroduce() else {
            showIntroduce(difficulty: difficulty)
            return
        }
        
        game = Game.init(difficulty: Game.Difficulty.init(rawValue: difficulty))
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
            monsterNames.remove(at:monsterNames.index(of: name)!)
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
        gameResults = GameResults.init(result: result, state: MonsterGameFlow.GameResults.State.init(rawValue: result > game.limit ? 0 : 1))
        let controller = MonsterGameResultsViewController.instantiate(fromStoryboard: .monster)
        controller.input = MonsterGameResultsViewController.Input(gameResult: gameResults)
        controller.output = MonsterGameResultsViewController.Output(openNext: openNext)
        master?.router?.presentModalChild(viewController: controller)
    }
    
    private func openNext() {
        switch gameResults.state {
        case .win:
            randomRound()
        case .lose:
            startGame()
        }
    }
    
    private func showIntroduce(difficulty: Int) {
        let controller = IntroduceVideoViewController.instantiate(fromStoryboard: .common)
        controller.video = .start
        master?.router?.introduceController(viewController: controller, completion: {
            self.startFlow(difficulty: difficulty)
        })
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
        
        init(difficulty: Difficulty?) {
            guard let diff = difficulty else {
                self.difficulty = Difficulty.easy
                return
            }
            self.difficulty = diff
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
        let state: State
        
        enum State: Int {
            case lose = 0
            case win = 1
        }
        
        init(result: Int, state: State?) {
            self.result = result
            guard let gameState = state else {
                self.state = State.win
                return
            }
            self.state = gameState
        }
    }
}
