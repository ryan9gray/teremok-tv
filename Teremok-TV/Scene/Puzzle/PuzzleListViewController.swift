//
//  PuzzleListViewController.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 22.03.2020.
//  Copyright © 2020 xmedia. All rights reserved.
//

import UIKit

class PuzzleListViewController: GameViewController {
	var input: Input!
	var output: Output!

	struct Output {
		let difficulty: (PuzzleGameFlow.Game.Difficulty) -> Void
		let start: (UIImage?) -> Void

	}

	struct Input {
		var items: [PuzzleMaster.Puzzle]
	}
	@IBOutlet private var diffButtons: [KeyButton]!
	@IBOutlet private var startEasy: KeyButton!
	@IBOutlet private var startMedium: KeyButton!
	@IBOutlet private var startHard: KeyButton!
	@IBOutlet private var collectionView: UICollectionView!

	@IBAction func startGame(_ sender: UIButton) {
		diffButtons.forEach { $0.setTitleColor(UIColor.white, for: .normal) }
		sender.setTitleColor(UIColor.Label.darkBlue, for: .normal)
		output.difficulty(PuzzleGameFlow.Game.Difficulty(rawValue: sender.tag)!)
	}

    override func viewDidLoad() {
        super.viewDidLoad()

        prepareUI()
		displayTags(items: input.items)
    }

	func prepareUI() {
		startEasy.setTitleColor(UIColor.Label.darkBlue, for: .normal)
		startEasy.gradientColors = Style.Gradients.green.value
		startMedium.gradientColors = Style.Gradients.orange.value
		startHard.gradientColors = Style.Gradients.red.value
		collectionView.delegate = self
		collectionView.dataSource = self
		let cells = [SearchCharacterCollectionViewCell.self, LoadingCollectionViewCell.self]
		collectionView.register(cells: cells)
	}
	func displayTags(items: [PuzzleMaster.Puzzle]){
		collectionView.reloadData()
	}

}
extension PuzzleListViewController: UICollectionViewDataSource {

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return input.items.count //+ (self.interactor!.hasMore ? 1 : 0)
	}
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		if indexPath.row == input.items.count {
			let cell = collectionView.dequeueReusableCell(withCell: LoadingCollectionViewCell.self, for: indexPath)
			return cell
		}
		let cell = collectionView.dequeueReusableCell(withCell: SearchCharacterCollectionViewCell.self, for: indexPath)
		cell.linktoLoad = input.items[indexPath.row].imageLink
		return cell
	}

}
extension PuzzleListViewController: UICollectionViewDelegate {

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let cell = collectionView.cellForItem(at: indexPath) as? SearchCharacterCollectionViewCell
		output.start(cell?.imageView.image)
	}
	func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

	}
}
extension PuzzleListViewController: UICollectionViewDelegateFlowLayout {

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let h = collectionView.frame.height/2 - 10
		return CGSize(width: h, height: h)
	}
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 10
	}
}
