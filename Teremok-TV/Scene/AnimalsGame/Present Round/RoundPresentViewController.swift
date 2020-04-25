//
//  ChoiceAnimalViewController.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 25/05/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

import UIKit
import AVKit
import Lottie

class RoundPresentViewController: GameViewController, IntroduceViewController, AVAudioPlayerDelegate {
    var round: Int = 1
    var action: ((Bool) -> Void)?
    private var audioPlayer: AVAudioPlayer?
    @IBOutlet private var animationView: AnimationView!

    override func viewDidLoad() {
        super.viewDidLoad()

        animationView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        animationView.contentMode = .scaleAspectFill
        animationView.clipsToBounds = false
        animationView.loopMode = .playOnce
        animationView.animationSpeed = 1.0
        playSound(round: (round-1))
        playAnimation(round: (round-1))
    }

    func playAnimation(round: Int) {
        let name = animations[round]
        let av = Animation.named(name)
        animationView.animation = av
        animationView.play()
    }

    func playSound(round: Int) {
        guard let path = Bundle.main.path(forResource: sounds[round], ofType: "mp3") else {
            dismiss(animated: true) {
                self.action?(false)
            }
            return
        }
        let url = URL(fileURLWithPath: path)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
        } catch {
            print("no file)")
        }
        audioPlayer?.prepareToPlay()
        audioPlayer?.delegate = self
        audioPlayer?.play()
    }


    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("end playing")
        dismiss(animated: true) {
            self.action?(true)
        }
    }

    let animations = [
        "Round_1",
        "Round_2",
        "Round_3",
        "Round_4",
        "Round_5",
        "Round_6",
        "Round_7",
        "Round_8",
        "Round_9",
        "Round_10"
    ]
    let sounds = [
        "ready_r_1",
        "ready_r_2",
        "ready_r_3",
        "ready_r_4",
        "ready_r_5",
        "ready_r_6",
        "ready_r_7",
        "ready_r_8",
        "ready_r_9",
        "ready_r_10"
    ]
}
