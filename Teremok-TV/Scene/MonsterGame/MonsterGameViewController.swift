//
//  MonsterGameViewController.swift
//  Teremok-TV
//
//  Created by Дмитрий Грищенко on 19/08/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

import UIKit

class MonsterGameViewController: GameViewController {

    @IBOutlet private var timerBtn: KeyButton!
    @IBOutlet private var collectionView: UICollectionView!
    var input: Input!
    var output: Output!
    
    private var firstSelectedItem: MonsterCollectionViewCell?
    private var secondSelectedItem: MonsterCollectionViewCell?
    private var score = 0 {
        didSet {
            if (score == input.game.difficulty.fieldSize/2) {
                output.openResults(seconds)
                timer.invalidate()
            }
        }
    }
    private var timer = Timer()
    private var seconds = 0 {
        didSet {
            timerBtn.setTitle(PlayerHelper.stringFromTimeInterval(TimeInterval(seconds)), for: .normal)
            if (seconds >= limit) {
                timerBtn.setTitleColor(UIColor.Button.redTwo, for: .normal)
            }
        }
    }
    private var limit: Int {
        get {
            switch input.game.difficulty {
            case .easy:
                return 60
            case .medium:
                return 180
            case .hard:
                return 300
            }
        }
    }
    
    struct Output {
        let openResults: (Int) -> Void
    }
    
    struct Input {
        var game: MonsterGameFlow.Game
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timerBtn.gradientColors = Styles.Gradients.lightGray.value
        let cells = [MonsterCollectionViewCell.self]
        collectionView.register(cells: cells)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
            self.fireTimer()
        })
    }
    
    private func fireTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            self.seconds += 1
        }
    }
    
    func matchMonsters(cell: MonsterCollectionViewCell) {
        if (firstSelectedItem == nil) {
            firstSelectedItem = cell
            firstSelectedItem?.flipCard()
        }
        else {
            secondSelectedItem = cell
            secondSelectedItem?.flipCard() {
                if (self.firstSelectedItem?.item.matchId == self.secondSelectedItem?.item.matchId) {
                    self.score += 1
                    self.firstSelectedItem = nil
                    self.secondSelectedItem = nil
                }
                else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        self.firstSelectedItem?.flipCard()
                        self.secondSelectedItem?.flipCard()
                        self.firstSelectedItem = nil
                        self.secondSelectedItem = nil
                    })
                }
            }
        }
    }
}

extension MonsterGameViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return input.game.difficulty.fieldSize
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withCell: MonsterCollectionViewCell.self, for: indexPath)
        cell.configuration(monster: input.game.items[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        matchMonsters(cell: collectionView.cellForItem(at: indexPath) as! MonsterCollectionViewCell)
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if ((firstSelectedItem != nil) && (secondSelectedItem != nil)) {
            return false
        }
        return true
    }
}
extension MonsterGameViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height = collectionView.bounds.height / 2.2
        var width = collectionView.bounds.width / 4.2
        switch input.game.difficulty {
        case MonsterGameFlow.Game.Difficulty.medium:
            height = collectionView.bounds.height / 3.4
            width = collectionView.bounds.width / 4.4
            break
        case MonsterGameFlow.Game.Difficulty.hard:
            height = collectionView.bounds.height / 4.6
            width = collectionView.bounds.width / 6
            break
        default:
            break
        }
        return CGSize(width: width, height: height)
    }
}
