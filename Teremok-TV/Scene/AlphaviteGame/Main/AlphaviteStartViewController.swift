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
    @IBOutlet private var segmentController: TTSegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()

        segmentController.itemTitles = [ "Я учу алфавит", "Я знаю алфавит" ]
        segmentController.didSelectItemWith = { (index, title) -> () in
            switch index {
            case 0:
                LocalStore.alphaviteIsHard = false
            case 1:
                LocalStore.alphaviteIsHard = true
            default:
                break
            }
        }
        segmentController.selectItemAt(index: LocalStore.alphaviteIsHard ? 1 : 0)
    }
}
