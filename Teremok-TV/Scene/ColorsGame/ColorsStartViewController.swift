//
//  ColorsStartViewController.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 08/09/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

import UIKit
import AVFoundation
import Lottie

class ColorsStartViewController: GameViewController {
    @IBOutlet private var startButton: KeyButton!
    @IBOutlet private var brushView: UIView!
    private var animationView: AnimationView = AnimationView(name: "brushAnimation")
    private let imageFillter = ImageFillter()

    @IBAction private func startTap(_ sender: Any) {
        //buttonPlayer?.play()
        masterRouter?.startFlow(0)
    }
    
    @IBOutlet weak var easyButton: UIButton!
    @IBOutlet weak var hardButton: UIButton!
    
    @IBAction func difficultTap(_ sender: UIButton) {
        setDifficults(isHard: sender.tag == 88)
    }
    
    private func setDifficults(isHard: Bool) {
        if isHard {
            easyButton.isSelected = false
            hardButton.isSelected = true
        } else {
            easyButton.isSelected = true
            hardButton.isSelected = false
        }
        LocalStore.colorsIsHard = isHard
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setAnimation()
        easyButton.setBackgroundImage(UIImage(named: "icDifficultColorsGame"), for: .selected)
        easyButton.setBackgroundImage(imageFillter.monochrome(UIImage(named: "icDifficultColorsGame")), for: .normal)
        hardButton.setBackgroundImage(UIImage(named: "icDifficultColorsGame"), for: .selected)
        hardButton.setBackgroundImage(imageFillter.monochrome(UIImage(named: "icDifficultColorsGame")), for: .normal)
        setDifficults(isHard: LocalStore.colorsIsHard)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        animationView.play()
    }

    private func setAnimation() {
        animationView = AnimationView(name: "brushAnimation")
        animationView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .playOnce
        animationView.animationSpeed = 1.0
        animationView.frame = brushView.bounds
        brushView.addSubview(animationView)
    }
}
