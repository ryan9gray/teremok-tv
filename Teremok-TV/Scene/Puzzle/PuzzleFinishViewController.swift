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
	@IBOutlet private var titleLabel: StrokeLabel!
	@IBOutlet private var imageContainer: DesignableView!
	@IBOutlet private var imagewView: UIImageView!

	@IBAction private func playTap(_ sender: Any) {
		if isGood {
			output.nextChoice()
		} else {
			output.resume()
		}
	}

	var input: Input!
	var output: Output!

	struct Output {
		var nextChoice: () -> Void
		var resume: () -> Void
	}

	struct Input {
		var answers: [Bool]
	}

	var isGood = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
