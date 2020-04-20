//
//  GameMasterViewController.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 08/09/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

import UIKit
import AVFoundation

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

//        do {
//            //Preparation to play
//            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: .moviePlayback)
//            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
//        }
//        catch {
//            // report for an error
//        }
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

    deinit {
//        do {
//            //Preparation to play - Костыль
//            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.ambient, mode: .moviePlayback)
//            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
//        }
//        catch {
//            // report for an error
//        }
    }
}
