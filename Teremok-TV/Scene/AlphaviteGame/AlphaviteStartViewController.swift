//
//  AlphaviteStartViewController.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 03/08/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

import UIKit
import AVFoundation

class AlphaviteStartViewController: GameStartViewController {
    @IBOutlet private var startButton: KeyButton!

    @IBAction private func startTap(_ sender: Any) {
        buttonPlayer?.play()
        masterRouter?.startFlow(0)
    }

    @IBAction func avatarClick(_ sender: Any) {
        masterRouter?.openStatistic()
    }

    @IBOutlet private var segmentController: TTSegmentedControl!
    private var audioPlayer: AVAudioPlayer?
    private var buttonPlayer: AVAudioPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()

        segmentController.itemTitles = [ "Я учу алфавит", "Я знаю алфавит" ]
        segmentController.selectedTextColor = UIColor.Label.titleText
        segmentController.defaultTextColor = UIColor.Label.titleText
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

        guard let mainSound = Bundle.main.path(forResource: AlphaviteMaster.Sound.main.rawValue, ofType: "wav")
        else {
            master?.present(errorString: "Игра загружается! Это может занять 1-2 минуты. Спасибо", completion: {
                self.masterRouter?.dismiss()
            })
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: mainSound))
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
        showTips()
    }
    
    func showTips() {
        if !avatarButton.isHidden, LocalStore.alphabetTip < 3 {
            LocalStore.alphabetTip += 1
            var preferences = EasyTipView.Preferences()
            preferences.drawing.font = Style.Font.istokWeb(size: 16)
            preferences.drawing.foregroundColor = UIColor.Base.darkBlue
            preferences.drawing.backgroundColor = .white
            preferences.drawing.arrowPosition = EasyTipView.ArrowPosition.right
            tipView = EasyTipView(text: "Здесь можно посмотреть статистику", preferences: preferences, delegate: self)
            tipView?.show(animated: true, forView: avatarButton, withinSuperview: view)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        audioPlayer?.pause()
    }
}
