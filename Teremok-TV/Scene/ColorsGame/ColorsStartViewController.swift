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
    @IBAction private func startTap(_ sender: Any) {
        //buttonPlayer?.play()
        masterRouter?.startFlow(0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setAnimation()
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
