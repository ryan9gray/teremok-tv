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

	func startFlow() {

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
