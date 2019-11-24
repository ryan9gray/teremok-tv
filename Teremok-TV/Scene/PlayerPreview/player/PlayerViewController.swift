//
//  PlayerViewController.swift
//  Teremok-TV
//
//  Created by R9G on 05/09/2018.
//  Copyright © 2018 xmedia. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class PlayerViewController: AVPlayerViewController {
    var playerAsset: AVURLAsset? {
        didSet {
            setVideoBack()
        }
    }
    var fullOverlay: TTPlayerViewController!
    
    override var player: AVPlayer? {
        didSet {
            guard let newPlayer = player else {
                return
            }
            fullOverlay.setPlayer(newPlayer)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        fullOverlay = TTPlayerViewController.instantiate(fromStoryboard: .play)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        showsPlaybackControls = false
        addChild(fullOverlay)
        view.addSubview(fullOverlay.view)
        fullOverlay.view.frame = view.bounds
        fullOverlay.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        fullOverlay.didMove(toParent: self)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        view.clipsToBounds = true
        view.bringSubviewToFront(fullOverlay.view)
        UIApplication.shared.beginReceivingRemoteControlEvents()
        becomeFirstResponder()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        UIApplication.shared.endReceivingRemoteControlEvents()
        resignFirstResponder()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        view.layer.cornerRadius = fullOverlay.isFullScreen ? 0 : 12
    }

    func setVideoBack(){
        guard let playerAsset = playerAsset else { return }
    
        playerAsset.resourceLoader.preloadsEligibleContentKeys = true
        let playerItem = AVPlayerItem(asset: playerAsset)
        if player != nil {
            player?.replaceCurrentItem(with: playerItem)
        }
        else {
            player = AVPlayer(playerItem: playerItem)
        }
        player?.allowsExternalPlayback = true
        player?.actionAtItemEnd = .none
        fullOverlay.startedPlaying()
    }
    
    deinit {
        print("PlayerViewController deinit")
        do {
            //Preparation to play - Костыль
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.ambient, mode: .moviePlayback)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
        }
        catch {
            // report for an error
        }
        fullOverlay.removeFromParent()
    }
}
