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
import Lottie

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
		titleLabel.textColor = .white
		playButton.gradientColors = [ UIColor.PuzzleGame.blueOne, UIColor.PuzzleGame.blueTwo ]
		do {
			audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "puzzle_win", ofType: "mp3")!))
			audioPlayer?.prepareToPlay()
		} catch {
			print("no file)")
		}
    }

	func addFireworks() {
		let animationView1 = AnimationView(animation: Animation.named("puzzle_firework_1"))
		let animationView2 = AnimationView(animation: Animation.named("puzzle_firework_2"))
		let animationView3 = AnimationView(animation: Animation.named("puzzle_firework_3"))
		let animations = [animationView1, animationView2, animationView3]

		let width = view.frame.width/3

		animations.forEach { animationView in
			animationView.isUserInteractionEnabled = false
			animationView.clipsToBounds = false
			animationView.frame.size = CGSize(width: width, height: width)
			view.addSubview(animationView)
		}
		animationView1.center = CGPoint(x: view.frame.width/2, y: width/2)
		animationView2.center = CGPoint(x: width, y: width)
		animationView3.center = CGPoint(x: view.frame.width-width, y: view.frame.height/2)

		animations.forEach { animationView in
			animationView.loopMode = .playOnce
			animationView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
			animationView.contentMode = .scaleAspectFill
			animationView.play { [weak animationView] finish in
				animationView?.isHidden = true
			}
		}
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		addFireworks()
		audioPlayer?.play()
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)

		audioPlayer?.stop()
	}
}
