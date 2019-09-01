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

    var contentURL : URL? {
        didSet{
            setVideoBack()
        }
    }
    
    var fullOverlay: TTPlayerViewController!
    
    override var player: AVPlayer? {
        didSet {
            guard let newPlayer = self.player else {
                return
            }
            self.fullOverlay.setPlayer(newPlayer)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        overlaySetup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addPlayerNotifications()
        addChild(fullOverlay)
        view.addSubview(fullOverlay.view)
        fullOverlay.view.frame = self.view.bounds
        fullOverlay.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        fullOverlay.didMove(toParent: self)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        view.bringSubviewToFront(fullOverlay.view)
        UIApplication.shared.beginReceivingRemoteControlEvents()
        becomeFirstResponder()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        UIApplication.shared.endReceivingRemoteControlEvents()
        self.resignFirstResponder()
    }
    
    func overlaySetup(){
        fullOverlay = TTPlayerViewController.instantiate(fromStoryboard: .play)
    }

    func setVideoBack(){
        guard let url = contentURL else { return }
        //player = AVPlayer(url: url)
        let testUrl = URL(string: "https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_4x3/bipbop_4x3_variant.m3u8")!
        
        let playerAsset = AVURLAsset(url: testUrl, options: .none)
        var playerItem: AVPlayerItem

        if url.absoluteString.hasPrefix("file:///") {
            let keys = ["tracks", "playable"];
            playerItem = AVPlayerItem(asset: playerAsset, automaticallyLoadedAssetKeys: keys)
        }
        else{
            playerItem = AVPlayerItem(asset: playerAsset)
        }
        if player != nil {
            player?.replaceCurrentItem(with: playerItem)
        }
        else {
            player = AVPlayer(playerItem: playerItem)
        }
        player?.allowsExternalPlayback = false
        player?.actionAtItemEnd = .none
        fullOverlay.playerLayer = AVPlayerLayer(player: player)
        fullOverlay.playerLayer.frame = fullOverlay.view.layer.bounds
        fullOverlay.playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        fullOverlay.startedPlaying()
    }

    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {

    }
    
    deinit {
        do {
            //Preparation to play - Костыль
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.ambient, mode: .moviePlayback)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
        }
        catch {
            // report for an error
        }
        removePlayerNotifations()
        //self.player = nil
        self.fullOverlay.removeFromParent()
        self.fullOverlay = nil
    }
}
extension PlayerViewController {
    
    @objc internal func applicationDidEnterBackground(_ notification: Notification) {

    }
    @objc internal func applicationWillEnterForeground(_ notification: Notification) {
    }
    @objc internal func playerItemDidPlayToEnd(_ notification: Notification) {
        print("playerItemDidPlayToEnd")
    }
    internal func addPlayerNotifications() {
        //NotificationCenter.default.addObserver(self, selector: .playerItemDidPlayToEndTime, name: .AVPlayerItemDidPlayToEndTime, object: nil)
        NotificationCenter.default.addObserver(self, selector: .applicationWillEnterForeground, name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: .applicationDidEnterBackground, name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    internal func removePlayerNotifations() {
        //NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
}

extension Selector {
    static let applicationWillEnterForeground = #selector(PlayerViewController.applicationWillEnterForeground(_:))
    static let applicationDidEnterBackground = #selector(PlayerViewController.applicationDidEnterBackground(_:))
}
