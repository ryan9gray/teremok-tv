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
	}

	var game = Game(difficulty: .easy)

	func startFlow() {
		openList()
	}

	func openList() {
		let controller = PuzzleListViewController.instantiate(fromStoryboard: .puzzle)
		controller.input = PuzzleListViewController.Input(items: PuzzleMaster.firstPack + PuzzleMaster.secondPack)
		controller.output = PuzzleListViewController.Output(
			difficulty: { [weak self] dif in
				self?.game.difficulty = dif
			},
			start: startPlay
		)
		master?.router?.pushChild(controller)//presentModalChild(viewController: controller)
	}
	var puzzles = LocalStore.puzzlesDone

	func startPlay(name: String) {
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
				self.puzzles.append(name)
				LocalStore.puzzlesDone = self.puzzles
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
