//
//  AlphaviteStartViewController.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 03/08/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

import UIKit

class AlphaviteStartViewController: GameViewController {
    @IBOutlet private var startButton: KeyButton!

    @IBAction private func startTap(_ sender: Any) {
        masterRouter?.startFlow(0)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
