//
//  MonsterGameViewController.swift
//  Teremok-TV
//
//  Created by Дмитрий Грищенко on 19/08/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

import UIKit

class MonsterGameViewController: GameViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var input: Input!
    var output: Output!
    
    struct Output {
        
    }
    
    struct Input {
        var game: MonsterGameFlow.Game
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cells = [MonsterCollectionViewCell.self]
        collectionView.register(cells: cells)
        // Do any additional setup after loading the view.
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
