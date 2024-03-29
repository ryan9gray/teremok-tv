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
		let start: (String) -> Void
		let setSort: (Int) -> [String]
		//let fetchPuzzle: (@escaping ([String]) -> Void) -> Void
	}

	struct Input {
		var items: [String]
		var allFetched: () -> Bool
	}

	var dones: Set<String> = []
	@IBOutlet var sortButtons: [UIRoundedButtonWithGradientAndShadow]!

	@IBOutlet var allSortButton: UIRoundedButtonWithGradientAndShadow!
	@IBAction func sortTap(_ sender: UIRoundedButtonWithGradientAndShadow) {
		sortButtons.forEach { button in
			button.gradientColors = [ UIColor.white, UIColor.white ]
			button.borderColor = UIColor.PuzzleGame.orangeTwo
			button.setTitleColor(UIColor.PuzzleGame.orangeTwo, for: .normal)
		}
		sender.gradientColors = [ UIColor.PuzzleGame.orangeTwo, UIColor.PuzzleGame.orangeOne  ]
		sender.borderColor = UIColor.clear
		sender.setTitleColor(UIColor.white, for: .normal)
		items = output.setSort(sender.tag)
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
		items = input.items
    }

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		dones = Set(LocalStore.puzzlesDone)
		collectionView.reloadData()
	}

	var items: [String] = [] {
		didSet {
			collectionView.reloadData()
		}
	}

	func prepareUI() {
		startEasy.setTitleColor(UIColor.Label.darkBlue, for: .normal)
		startEasy.gradientColors = [ UIColor.PuzzleGame.greenOne, UIColor.PuzzleGame.greenTwo ]
		startMedium.gradientColors = [ UIColor.PuzzleGame.orangeTwo, UIColor.PuzzleGame.orangeOne ]
		startHard.gradientColors = [ UIColor.PuzzleGame.redTwo, UIColor.PuzzleGame.redOne ]
		collectionView.delegate = self
		collectionView.dataSource = self
		let cells = [PuzzleCollectionViewCell.self, LoadingCollectionViewCell.self]
		collectionView.register(cells: cells)
		sortButtons.forEach { button in
			button.gradientColors = [ UIColor.white, UIColor.white ]
			button.borderColor = UIColor.PuzzleGame.orangeTwo
			button.setTitleColor(UIColor.PuzzleGame.orangeTwo, for: .normal)
			button.borderWidth = 2
		}
		allSortButton.gradientColors = [ UIColor.PuzzleGame.orangeOne, UIColor.PuzzleGame.orangeTwo ]
		allSortButton.borderColor = .clear
		allSortButton.setTitleColor(UIColor.white, for: .normal)
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
		let cell = collectionView.dequeueReusableCell(withCell: PuzzleCollectionViewCell.self, for: indexPath)

		let name = items[indexPath.row]
		cell.setImage(UIImage(named: name), done: dones.contains(name))
		return cell
	}

}
extension PuzzleListViewController: UICollectionViewDelegate {

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		output.start(items[indexPath.row])
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
