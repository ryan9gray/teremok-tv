//
//  ColorsStartViewController.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 08/09/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

import UIKit
import AVFoundation
import Lottie

class ColorsStartViewController: GameStartViewController {
    @IBOutlet private var startButton: KeyButton!
    @IBOutlet private var brushView: UIView!
    private var animationView: AnimationView = AnimationView(name: "brushAnimation")
    private let imageFillter = ImageFillter()
    private var audioPlayer: AVAudioPlayer?

    @IBAction private func startTap(_ sender: Any) {
        //buttonPlayer?.play()
        masterRouter?.startFlow(0)
    }
    
    @IBOutlet weak var easyButton: UIButton!
    @IBOutlet weak var hardButton: UIButton!
    @IBAction func avatarClick(_ sender: Any) {
        masterRouter?.openStatistic()
    }
    
    @IBAction func difficultTap(_ sender: UIButton) {
        setDifficults(isHard: sender.tag == 88)
    }
    
    private func setDifficults(isHard: Bool) {
        if isHard {
            easyButton.isSelected = false
            hardButton.isSelected = true
        } else {
            easyButton.isSelected = true
            hardButton.isSelected = false
        }
        LocalStore.colorsIsHard = isHard
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setAnimation()
        easyButton.setBackgroundImage(UIImage(named: "icDifficultColorsGame"), for: .selected)
        easyButton.setBackgroundImage(imageFillter.monochrome(UIImage(named: "icDifficultColorsGame")), for: .normal)
        hardButton.setBackgroundImage(UIImage(named: "icDifficultColorsGame"), for: .selected)
        hardButton.setBackgroundImage(imageFillter.monochrome(UIImage(named: "icDifficultColorsGame")), for: .normal)
        setDifficults(isHard: LocalStore.colorsIsHard)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        audioPlayer?.pause()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        guard let mainSound = Bundle.main.path(forResource: ColorsMaster.Sound.main.rawValue, ofType: "wav")
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
        animationView.play()
        showTips()
    }

    func showTips() {
        if !avatarButton.isHidden, LocalStore.colorsGameTip < 3 {
            LocalStore.colorsGameTip += 1
            var preferences = EasyTipView.Preferences()
            preferences.drawing.font = Style.Font.istokWeb(size: 16)
            preferences.drawing.foregroundColor = UIColor.Base.darkBlue
            preferences.drawing.backgroundColor = .white
            preferences.drawing.arrowPosition = EasyTipView.ArrowPosition.right
            tipView = EasyTipView(text: "Здесь можно посмотреть статистику", preferences: preferences, delegate: self)
            tipView?.show(animated: true, forView: avatarButton, withinSuperview: view)
        }
    }

    private func setAnimation() {
        animationView = AnimationView(name: "brushAnimation")
        animationView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .playOnce
        animationView.animationSpeed = 1.0
        animationView.frame = brushView.bounds
        brushView.addSubview(animationView)
    }
}
