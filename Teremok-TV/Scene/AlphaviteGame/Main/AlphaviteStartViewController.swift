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
    @IBOutlet private var difficulteSegmentControl: UISegmentedControl!

    @IBAction private func startTap(_ sender: Any) {
        masterRouter?.startFlow(0)
    }
    
    @IBAction private func difficultsChange(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            LocalStore.alphaviteIsHard = false
        case 1:
            LocalStore.alphaviteIsHard = true
        default:
            break
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        difficulteSegmentControl.selectedSegmentIndex = LocalStore.alphaviteIsHard ? 1 : 0
    }
}
