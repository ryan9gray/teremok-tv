//
//  PuzzleFinishViewController.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 22.03.2020.
//  Copyright © 2020 xmedia. All rights reserved.
//

import UIKit
import Spring

class PuzzleFinishViewController: GameViewController {
	@IBOutlet private var playButton: KeyButton!
	@IBOutlet private var titleLabel: UILabel!
	@IBOutlet private var imageContainer: DesignableView!
	@IBOutlet private var imagewView: UIImageView!

	@IBAction private func playTap(_ sender: Any) {
		output.nextChoice()
	}

	var input: Input!
	var output: Output!

	struct Output {
		var nextChoice: () -> Void
	}

	struct Input {
		let image: UIImage?
	}


    override func viewDidLoad() {
        super.viewDidLoad()

		titleLabel.addTxtShadow()
		imagewView.image = input.image
		titleLabel.text = "Молодец! Выбери следующую картинку!"
		playButton.gradientColors = [ UIColor.PuzzleGame.blueOne, UIColor.PuzzleGame.blueTwo ]
    }

}
