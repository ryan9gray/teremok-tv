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
            if (seconds >= input.game.limit) {
                timerBtn.setTitleColor(UIColor.Button.redThree, for: .normal)
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
    }

    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)

        collectionView.performBatchUpdates(nil) { result in
            self.start()
        }
    }

    private func start() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            self.fireTimer()
            self.collectionView.visibleCells.forEach { ($0 as? MonsterCollectionViewCell)?.close() }
        })
    }

    private func fireTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            self.seconds += 1
        }
    }
    
    func saveSelectedCell(cell: MonsterCollectionViewCell) {
        if (firstSelectedItem == nil) {
            firstSelectedItem = cell
        }
        else {
            secondSelectedItem = cell
        }
    }
    
    func matchMonsters() {
        if (firstSelectedItem!.flipped && secondSelectedItem!.flipped) {
            if (firstSelectedItem?.item.matchId == secondSelectedItem?.item.matchId) {
                score += 1
                flipBack(shouldFlip: false)
            }
            else {
                flipBack(shouldFlip: true)
            }
        }
    }
    
    func flipBack(shouldFlip: Bool) {
        if shouldFlip {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.firstSelectedItem?.close()
                self.secondSelectedItem?.close()
                self.firstSelectedItem = nil
                self.secondSelectedItem = nil
            })
        }
        else {
            firstSelectedItem = nil
            secondSelectedItem = nil
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
        guard let selectedCell = collectionView.cellForItem(at: indexPath) as? MonsterCollectionViewCell else { return }

        saveSelectedCell(cell: selectedCell)
        selectedCell.open { [weak self] in
            guard self?.firstSelectedItem != nil && self?.secondSelectedItem != nil else { return }

            self?.matchMonsters()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if ((firstSelectedItem == nil) || ((secondSelectedItem == nil) && firstSelectedItem != collectionView.cellForItem(at: indexPath))) {
            return true
        }
        return false
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
