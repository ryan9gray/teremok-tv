//
//  DinoStartViewController.swift
//  Teremok-TV
//
//  Created by Виктор Пузаков on 06.04.2020.
//  Copyright © 2020 xmedia. All rights reserved.
//

import UIKit
import AVKit

class DinoStartViewController: GameStartViewController {
    @IBOutlet private var startEasy: KeyButton!
    @IBOutlet private var startMedium: KeyButton!
    @IBOutlet private var startHard: KeyButton!
    private var buttonPlayer: AVAudioPlayer?
    private var audioPlayer: AVAudioPlayer?

    @IBAction func startGame(_ sender: UIButton) {
        buttonPlayer?.play()
        masterRouter?.startFlow(sender.tag)
    }

    @IBAction func avatarClick(_ sender: Any) {
        masterRouter?.openStatistic()
     }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        startMedium.gradientColors = Style.Gradients.green.value
        startHard.gradientColors = Style.Gradients.orange.value
        let menuMusic = URL(fileURLWithPath: Bundle.main.path(forResource: "monster_menu", ofType: "mp3")!)

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: menuMusic)
            audioPlayer?.prepareToPlay()
        } catch {
            print("no file)")
        }
        do {
            buttonPlayer = try AVAudioPlayer(contentsOf: DinoMaster.Sound.main.url)
            buttonPlayer?.prepareToPlay()
        } catch {
            print("no file)")
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        audioPlayer?.play()
        showTips()
    }

    private func showTips() {
        if !avatarButton.isHidden, LocalStore.dinoTip < 3 {
           LocalStore.dinoTip += 1
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
