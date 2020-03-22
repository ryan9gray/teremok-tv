//
//  PuzzleListViewController.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 22.03.2020.
//  Copyright © 2020 xmedia. All rights reserved.
//

import UIKit

class PuzzleListViewController: UIViewController {
	var input: Input!
	var output: Output!

	struct Output {
		let startWith: (PuzzleGameFlow.Game.Difficulty) -> Void
	}

	struct Input {
		var chars: [String]
	}

	var items: [PuzzleMaster.Puzzle] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

}
extension PuzzleListViewController: UICollectionViewDataSource {

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return items.count //+ (self.interactor!.hasMore ? 1 : 0)
	}
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		if indexPath.row == items.count {
			let cell = collectionView.dequeueReusableCell(withCell: LoadingCollectionViewCell.self, for: indexPath)
			return cell
		}
		let cell = collectionView.dequeueReusableCell(withCell: SearchCharacterCollectionViewCell.self, for: indexPath)
		cell.linktoLoad = items[indexPath.row].imageLink
		return cell
	}

}
extension PuzzleListViewController: UICollectionViewDelegate {

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

	}
	func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

	}
}
extension PuzzleListViewController: UICollectionViewDelegateFlowLayout {

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: 110, height: 65)
	}
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 10
	}
}
