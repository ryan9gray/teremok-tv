//
//  PuzzleFlow.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 22.03.2020.
//  Copyright © 2020 xmedia. All rights reserved.
//

import UIKit

class PuzzleGameFlow  {
	weak var master: PuzzleMasterViewController?

	init(master: PuzzleMasterViewController) {
		self.master = master
		onDemand()
	}

	var game = Game(difficulty: .easy)
	var puzzlesDone = LocalStore.puzzlesDone
	var allPuzzles = PuzzleMaster.firstPack

	func startFlow() {
		openList()
	}

	func openList() {
		let controller = PuzzleListViewController.instantiate(fromStoryboard: .puzzle)
		controller.input = PuzzleListViewController.Input(items: allPuzzles, allFetched: { self.allFetched })
		controller.output = PuzzleListViewController.Output(
			difficulty: { [weak self] dif in
				self?.game.difficulty = dif
			},
			start: startPlay,
			setSort: getSort
		)
		master?.router?.pushChild(controller)//presentModalChild(viewController: controller)
	}


	func getSort(_ index: Int) -> [String] {
		switch index {
			case 1:
				return allPuzzles
			case 2:
				return puzzlesDone
			case 3:
				return allPuzzles.filter { puzzlesDone.contains($0) }
			default:
				return []
		}
	}

	func startPlay(name: String) {
		if !(Profile.current?.premiumGame ?? false), puzzlesDone.count >= 3 {
			buyAlert()
			return
		}
		let image = UIImage(named: name)
		let controller = PuzzlePlaygroundViewController.instantiate(fromStoryboard: .puzzle)
		controller.input = PuzzlePlaygroundViewController.Input(
			image: image,
			difficulty: game.difficulty
		)
		controller.output = PuzzlePlaygroundViewController.Output(
			finish: { [weak self] in
				guard let self = self else { return }

				self.finishRound(image: image)
				if !self.puzzlesDone.contains(name) {
					self.puzzlesDone.append(name)
					LocalStore.puzzlesDone = self.puzzlesDone
				}
			}
		)
		master?.router?.presentModalChild(viewController: controller)
	}

	private func finishRound(image: UIImage?) {
		let controller = PuzzleFinishViewController.instantiate(fromStoryboard: .puzzle)
		controller.input = PuzzleFinishViewController.Input(image: image)
		controller.output = PuzzleFinishViewController.Output(
			nextChoice: nextRound
		)
		master?.router?.presentModalChild(viewController: controller)
	}

	private func nextRound() {
		master?.router?.popChild()
	}

	var allFetched: Bool = false

	func onDemand() {
		if UIImage(named: "puzzle_16") != nil {
			self.allFetched = true
			self.allPuzzles.append(contentsOf: PuzzleMaster.secondPack + PuzzleMaster.thirdPack)
		} else {
			let alertController = UIAlertController(title: "Остальные картинки еще не загрузились", message: nil, preferredStyle: .alert)
			alertController.addAction(UIAlertAction(title: "Ок", style: .default))
			master?.present(alertController, animated: true, completion: nil)
		}
	}
	
	deinit {
		print("Logger: GameFlow deinit")
	}

	private func authAlert() {
		master?.presentCloud(title: "", subtitle: Main.Messages.auth, button: "Зарегистрироваться") { [weak self] in
			self?.master?.openAutorization()
		}
	}

	private func buyAlert() {
		let vc = CloudAlertViewController.instantiate(fromStoryboard: .alerts)
		let text = Main.Messages.buyGames
		vc.model = AlertModel(title: "", subtitle: text, buttonTitle: "В настройки")
		vc.modalTransitionStyle = .crossDissolve
		vc.modalPresentationStyle = .overCurrentContext
		vc.complition = { [weak self] in
			self?.master?.openSettings()
		}
		master?.presentAlertModally(alertController: vc)
	}

	struct Game {
		var difficulty: Difficulty

		enum Difficulty: Int {
			case easy = 3
			case medium = 6
			case hard = 9

			var fieldSize: Int {
				switch self {
					case .easy:
						return 3
					case .medium:
						return 6
					case .hard:
						return 9
				}
			}
		}
	}
}
