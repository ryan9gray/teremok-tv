//
//  PuzzleStartViewController.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 22.03.2020.
//  Copyright © 2020 xmedia. All rights reserved.
//

import UIKit
import AVFoundation

class PuzzleStartViewController: GameStartViewController {
	@IBOutlet private var startButton: KeyButton!
	private var audioPlayer: AVAudioPlayer?
	private var buttonPlayer: AVAudioPlayer?

	@IBAction private func startTap(_ sender: Any) {
		buttonPlayer?.play()
		masterRouter?.startFlow(0)
	}
	
	@IBAction func avatarClick(_ sender: Any) {
		masterRouter?.openStatistic()
	}

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

	override func viewWillDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)

		audioPlayer?.pause()
	}

}
