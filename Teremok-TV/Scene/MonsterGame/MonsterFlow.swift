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
            let monster = MonsterMaster.Monster(imageName: name, matchId: idx, flipped: true)
            game.items.append(monster)
            game.items.append(monster)
            monsterNames.remove(at:monsterNames.index(of: name)!)
        }
        game.items.shuffle()
    }
    
    private func startGame() {
        let controller = MonsterGameViewController.instantiate(fromStoryboard: .monster)
        controller.input = MonsterGameViewController.Input(game: game)
//        controller.output = MonsterGameViewController.Output(startChoice: startChoice)
        master?.router?.presentModalChild(viewController: controller)
    }
    
    private func showIntroduce(difficulty: Int) {
        let controller = IntroduceAnimalViewController.instantiate(fromStoryboard: .alphavite)
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
            if let diff = difficulty {
                self.difficulty = diff
            }
            else {
                self.difficulty = Difficulty.easy
            }
        }
        
        let difficulty: Difficulty
        var items = [MonsterMaster.Monster]()
    }
}
