//
//  PuzzleFinishViewController.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 22.03.2020.
//  Copyright © 2020 xmedia. All rights reserved.
//

import UIKit
import Spring
import AVKit

class PuzzleFinishViewController: GameViewController {
	@IBOutlet private var playButton: KeyButton!
	@IBOutlet private var titleLabel: UILabel!
	@IBOutlet private var imageContainer: DesignableView!
	@IBOutlet private var imagewView: UIImageView!
	private var audioPlayer: AVAudioPlayer?

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
		do {
			audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "puzzle_win", ofType: "wav")!))
			audioPlayer?.prepareToPlay()
		} catch {
			print("no file)")
		}
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		audioPlayer?.play()
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)

		audioPlayer?.stop()
	}

}
