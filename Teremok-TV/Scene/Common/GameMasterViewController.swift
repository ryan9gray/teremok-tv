//
//  GameMasterViewController.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 08/09/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

import UIKit

class GameMasterViewController: UIViewController {
    @IBOutlet var backgroundView: UIImageView!
    @IBOutlet var homeBtn: KeyButton!
    let startTime = Date()

    var output: Output!

    struct Output {
        var openSettings: () -> Void
        var openAuthorization: () -> Void
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    func openSettings() {
        dismiss(animated: true) {
            self.output.openSettings()
        }
    }

    func openAutorization() {
        dismiss(animated: true) {
            self.output.openAuthorization()
        }
    }
}
