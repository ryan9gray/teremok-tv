//
//  MonsterStartViewController.swift
//  Teremok-TV
//
//  Created by Дмитрий Грищенко on 14/08/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

import UIKit
import AVFoundation

class MonsterStartViewController: GameViewController {
    @IBOutlet private var startEasy: KeyButton!
    @IBOutlet private var startMedium: KeyButton!
    @IBOutlet private var startHard: KeyButton!
    
    private var buttonPlayer = AVAudioPlayer()
    private var bgMusicPlayer = AVAudioPlayer()

    @IBAction func startGame(_ sender: UIButton) {
        buttonPlayer.play()
        masterRouter?.startFlow(sender.tag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        startMedium.gradientColors = Style.Gradients.green.value
        startHard.gradientColors = Style.Gradients.orange.value
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let menuMusic = URL(fileURLWithPath: Bundle.main.path(forResource: "monster_menu", ofType: "mp3")!)
        
        do {
            bgMusicPlayer = try AVAudioPlayer(contentsOf: menuMusic)
            bgMusicPlayer.prepareToPlay()
        } catch {
            print("no file)")
        }
        bgMusicPlayer.play()
        
        do {
            buttonPlayer = try AVAudioPlayer(contentsOf: MonsterMaster.Sound.main.url)
            buttonPlayer.prepareToPlay()
        } catch {
            print("no file)")
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        bgMusicPlayer.stop()
    }
}
