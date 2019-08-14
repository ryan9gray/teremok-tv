//
//  AlphaviteMainViewController.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 03/08/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

import UIKit

class AlphaviteMainViewController: GameViewController {
    @IBOutlet private var playButton: KeyButton!

    @IBAction private func playTap(_ sender: Any) {
        masterRouter?.startFlow(0)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        playButton.gradientColors = Styles.Gradients.alphavitePlay.value
    }

}
