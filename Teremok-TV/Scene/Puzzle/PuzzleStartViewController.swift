//
//  PuzzleStartViewController.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 22.03.2020.
//  Copyright © 2020 xmedia. All rights reserved.
//

import UIKit
import AVFoundation

class PuzzleStartViewController: GameViewController {
	@IBOutlet private var startButton: KeyButton!
	private var audioPlayer: AVAudioPlayer?
	private var buttonPlayer: AVAudioPlayer?

	@IBAction private func startTap(_ sender: Any) {
		buttonPlayer?.play()
		masterRouter?.startFlow(0)
	}

    override func viewDidLoad() {
        super.viewDidLoad()

		startButton.gradientColors = [ UIColor.PuzzleGame.orangeTwo, UIColor.PuzzleGame.orangeOne ]
		do {
			audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "puzzle_main", ofType: "mp3")!))
			audioPlayer?.prepareToPlay()
		} catch {
			print("no file)")
		}

		do {
			buttonPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "push_button_sound", ofType: "wav")!))
			buttonPlayer?.prepareToPlay()
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
