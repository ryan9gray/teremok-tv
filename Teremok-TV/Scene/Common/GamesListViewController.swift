//
//  GamesListViewController.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 01/08/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

import UIKit
import Spring
import AVFoundation

class GamesListViewController: AbstracViewController {
    var output: Output!

    struct Output {
        var openAnimals: () -> Void
        var openAlphavite: () -> Void
        var openMonster: () -> Void
        var openColors: () -> Void
		var openPuzzle: () -> Void

    }
    @IBOutlet var buttons: [DesignableButton]!
    
    @IBOutlet private var titleLabel: StrokeLabel!
    @IBOutlet private var homeBtn: KeyButton!
    private var buttonPlayer: AVAudioPlayer?

    @IBAction private func homeClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func touchDownGame(_ sender: Any) {
        buttonPlayer?.play()
    }

    @IBAction func animalsTap(_ sender: Any) {
        self.dismiss(animated: true) {
            self.output.openAnimals()
        }
    }
	@IBAction func puzzleTap(_ sender: Any) {
		self.dismiss(animated: true) {
			self.output.openPuzzle()
		}
	}

    @IBAction func alphaviteTap(_ sender: Any) {
        self.dismiss(animated: true) {
            self.output.openAlphavite()
        }
    }

    @IBAction func monsterTap(_ sender: Any) {
        self.dismiss(animated: true) {
            self.output.openMonster()
        }
    }
    @IBAction func colorsTap(_ sender: Any) {
        self.dismiss(animated: true) {
            self.output.openColors()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        homeBtn.gradientColors = Style.Gradients.brown.value
        titleLabel.attributedText = "ВЫБЕРИТЕ ИГРУ:" <~ Style.TextAttributes.gameList
        Style.Label.ColorsGameStrokeTitle(titleLabel: titleLabel, gradient: Style.Gradients.blue.value)

        do {
              buttonPlayer = try AVAudioPlayer(contentsOf: MonsterMaster.Sound.main.url)
              buttonPlayer?.prepareToPlay()
          } catch {
              print("no file)")
          }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        buttons.forEach { $0.animate() }
    }
}
