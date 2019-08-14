//
//  IntroduceAnimalViewController.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 25/05/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

import UIKit
import AVKit

class IntroduceAnimalViewController: GameViewController, IntroduceViewController {
    @IBOutlet private var videoBackView: RoundCornerView!

    var video: PrincessMovie!
    var action: (() -> Void)?

    @IBAction func nextClick(_ sender: Any) {
        action?()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        playVideo()
    }

    var avPlayer: AVPlayer!
    var avPlayerLayer: AVPlayerLayer!

    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        avPlayer.pause()
    }

    override func viewWillLayoutSubviews() {
        avPlayerLayer.frame = videoBackView.layer.bounds
    }

    private func playVideo() {
        guard
            let moviePath = Bundle.main.path(forResource: video.rawValue, ofType: "mp4")
        else { return }

        let videoURL = URL(fileURLWithPath: moviePath)
        avPlayer = AVPlayer(url: videoURL)
        avPlayerLayer = AVPlayerLayer(player: avPlayer)
        avPlayerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        avPlayer.actionAtItemEnd = .none
        videoBackView.layer.addSublayer(avPlayerLayer)
        avPlayerLayer.frame = videoBackView.layer.bounds

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.avPlayer.play()
        }
    }

    enum PrincessMovie: String {
        case introduce = "scene-1"
        case start = "scene-2"
    }
}
