//
//  MonsterGameViewController.swift
//  Teremok-TV
//
//  Created by Дмитрий Грищенко on 19/08/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

import UIKit
import AVFoundation

class MonsterGameViewController: GameViewController {
    @IBOutlet private var timerBtn: KeyButton!
    @IBOutlet private var collectionView: UICollectionView!
    var input: Input!
    var output: Output!
    
    private var audioPlayer: AVAudioPlayer?
    private var closeAudioPlayer: AVAudioPlayer?
    private var firstSelectedItem: MonsterCollectionViewCell?
    private var secondSelectedItem: MonsterCollectionViewCell?
    private var score = 0 {
        didSet {
            if score == input.game.difficulty.fieldSize/2 {
                output.openResults(seconds)
                timer.invalidate()
            }
        }
    }
    private var timer = Timer()
    private var seconds = 0 {
        didSet {
            timerBtn.setTitle(PlayerHelper.stringFromTimeInterval(TimeInterval(seconds)), for: .normal)
            if seconds >= input.game.limit {
                timerBtn.setTitleColor(UIColor.Button.red, for: .normal)
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
        timerBtn.gradientColors = Style.Gradients.lightGray.value
        let cells = [MonsterCollectionViewCell.self]
        collectionView.register(cells: cells)
        collectionView.isUserInteractionEnabled = false
    }

    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)

        collectionView.performBatchUpdates(nil) { result in
            self.start()
        }
    }

    private func start() {
        let time = input.game.difficulty.memTime
        DispatchQueue.main.asyncAfter(deadline: .now() + time, execute: {
            self.fireTimer()
            self.playSounds(MonsterMaster.Sound.closeAll.url)
            self.collectionView.visibleCells.forEach { ($0 as? MonsterCollectionViewCell)?.close() }
            self.collectionView.isUserInteractionEnabled = true
        })
    }

    func playSounds(_ url: URL, isOpenPlayer: Bool = true) {
        do {
            if isOpenPlayer {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.play()

            }
            else {
                closeAudioPlayer = try AVAudioPlayer(contentsOf: url)
                closeAudioPlayer?.play()
            }
        } catch {
            print("no file)")
        }
    }

    private func fireTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            self.seconds += 1
        }
    }
    
    func saveSelectedCell(cell: MonsterCollectionViewCell) {
        if firstSelectedItem == nil {
            firstSelectedItem = cell
        }
        else {
            secondSelectedItem = cell
        }
    }
    
    func matchMonsters() {
        if (firstSelectedItem?.flipped ?? true) && (secondSelectedItem?.flipped ?? true) {
            if firstSelectedItem?.item.imageName == secondSelectedItem?.item.imageName {
                score += 1
                playSounds(MonsterMaster.Sound.rightAnswer.url)
                firstSelectedItem?.bounceAnimation()
                secondSelectedItem?.bounceAnimation(completion: { [weak self] in
                    self?.flipBack(shouldFlip: false)
                })
            }
            else {
                flipBack(shouldFlip: true)
                playSounds(MonsterMaster.Sound.wrongAnswer.url)
            }
        }
    }
    
    func flipBack(shouldFlip: Bool) {
        if shouldFlip {
            self.firstSelectedItem?.shakeAnimation()
            self.secondSelectedItem?.shakeAnimation { [weak self] in
                self?.close()
            }
        }
        else {
            firstSelectedItem = nil
            secondSelectedItem = nil
        }
    }

    func close() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.firstSelectedItem?.close()
            self.secondSelectedItem?.close()
            self.playSounds(MonsterMaster.Sound.closeCards.url, isOpenPlayer: false)
            self.firstSelectedItem = nil
            self.secondSelectedItem = nil
        })
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
}

extension MonsterGameViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedCell = collectionView.cellForItem(at: indexPath) as? MonsterCollectionViewCell else { return }
        guard !selectedCell.flipped else { return }
        
        saveSelectedCell(cell: selectedCell)
        if self.secondSelectedItem == nil {
            playSounds(MonsterMaster.Sound.openCard.url)
        }
        else {
            playSounds(MonsterMaster.Sound.openCard.url, isOpenPlayer: false)
        }
        selectedCell.open { [weak self] in
            guard self?.firstSelectedItem != nil && self?.secondSelectedItem != nil else { return }

            self?.matchMonsters()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if firstSelectedItem == nil || (secondSelectedItem == nil && firstSelectedItem != collectionView.cellForItem(at: indexPath)) {
            return true
        }
        return false
    }
}
