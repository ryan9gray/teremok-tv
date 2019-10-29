//
//  IntroduceVideoViewController.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 25/05/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

import UIKit
import AVKit

class IntroduceVideoViewController: GameViewController, IntroduceViewController {
    @IBOutlet private var videoBackView: UIView!
    @IBOutlet private var playButton: KeyButton!

    var video: PrincessMovie!
    var action: ((Bool) -> Void)?
    private var avPlayer: AVPlayer?
    private var avPlayerLayer: AVPlayerLayer!

    @IBAction private func nextClick(_ sender: Any) {
        dismiss(animated: true) {
            self.action?(true)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        playButton.isHidden = ServiceConfiguration.activeConfiguration() == .prod
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        playVideo()
    }


    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        avPlayer?.pause()
    }

    override func viewWillLayoutSubviews() {
        guard avPlayer != nil else { return }
        
        avPlayerLayer.frame = videoBackView.layer.bounds
    }

    private func playVideo() {
        guard
            let moviePath = Bundle.main.path(forResource: video.rawValue, ofType: "mp4")
        else {
            dismiss(animated: true) {
                self.action?(false)
            }
            return
        }

        let videoURL = URL(fileURLWithPath: moviePath)
        avPlayer = AVPlayer(url: videoURL)
        avPlayerLayer = AVPlayerLayer(player: avPlayer)
        avPlayerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        avPlayer?.actionAtItemEnd = .none
        videoBackView.layer.addSublayer(avPlayerLayer)
        avPlayerLayer.frame = videoBackView.layer.bounds
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerEnd), name: .AVPlayerItemDidPlayToEndTime, object: avPlayer!.currentItem)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.avPlayer?.play()
        }
    }

    @objc func playerEnd() {
        dismiss(animated: true) {
            self.action?(true)
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }

    enum PrincessMovie: String {
        case introduce = "scene-1"
        case start = "scene-2"
        case alphavite = "Pick_introduce"
        case monster = "monster_game_introduce"
        case colorsGame = "colorsGame_introduce"
    }
}
