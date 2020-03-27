//
//  MonsterStartViewController.swift
//  Teremok-TV
//
//  Created by Дмитрий Грищенко on 14/08/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

import UIKit
import AVKit

class MonsterStartViewController: GameStartViewController {
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
        startEasy.gradientColors = Style.Gradients.DinoGame.red.value
        startMedium.gradientColors = Style.Gradients.DinoGame.blue.value
        startHard.gradientColors = Style.Gradients.DinoGame.orange.value
        let menuMusic = URL(fileURLWithPath: Bundle.main.path(forResource: "monster_menu", ofType: "mp3")!)

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: menuMusic)
            audioPlayer?.prepareToPlay()
        } catch {
            print("no file)")
        }
        do {
            buttonPlayer = try AVAudioPlayer(contentsOf: MonsterMaster.Sound.main.url)
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
        if !avatarButton.isHidden, LocalStore.monsterTip < 3 {
           LocalStore.monsterTip += 1
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
