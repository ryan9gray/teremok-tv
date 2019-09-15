//
//  AlphaviteStartViewController.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 03/08/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

import UIKit
import AVFoundation

class AlphaviteStartViewController: GameViewController {
    @IBOutlet private var startButton: KeyButton!

    @IBAction private func startTap(_ sender: Any) {
        buttonPlayer?.play()
        masterRouter?.startFlow(0)
    }

    @IBOutlet private var segmentController: TTSegmentedControl!
    private var audioPlayer: AVAudioPlayer?
    private var buttonPlayer: AVAudioPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()


        segmentController.itemTitles = [ "Я учу алфавит", "Я знаю алфавит" ]
        segmentController.didSelectItemWith = { (index, title) -> () in
            self.buttonPlayer?.play()
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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: AlphaviteMaster.Sound.main.url)
            audioPlayer?.prepareToPlay()
        } catch {
            print("no file)")
        }
        audioPlayer?.play()

        do {
            buttonPlayer = try AVAudioPlayer(contentsOf: AlphaviteMaster.Sound.button.url)
            buttonPlayer?.prepareToPlay()
        } catch {
            print("no file)")
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        audioPlayer?.stop()
    }
}
