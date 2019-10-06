//
//  OnboardingViewController.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 26/06/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

import UIKit
import AVKit

class OnboardingViewController: UIViewController {
    private var avPlayer: AVPlayer?
    private var avPlayerLayer: AVPlayerLayer!
    @IBOutlet private var videoBackView: UIView!

    let bundleResourceRequest = NSBundleResourceRequest(tags: Set([OnDemandLoader.Tags.Initial.onBoarding.rawValue]))

    override func viewDidLoad() {
        super.viewDidLoad()

        access()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }

    func access() {
        bundleResourceRequest.conditionallyBeginAccessingResources { [unowned self] available in
            if available {
                DispatchQueue.main.async {
                    self.playVideo()
                }
              } else {
                self.bundleResourceRequest.beginAccessingResources { error in
                    self.access()
                  }
              }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        avPlayer?.pause()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        guard avPlayer != nil else { return }

        avPlayerLayer.frame = videoBackView.layer.bounds
    }

    private func playVideo() {
        guard let moviePath = Bundle.main.path(forResource: "OnBoarding", ofType: "mp4") else {
            ViewHierarchyWorker.setRootViewController(rootViewController: MasterViewController.instantiate(fromStoryboard: .main))
            dismiss(animated: true, completion: nil)
            return
        }

        let videoURL = URL(fileURLWithPath: moviePath)
        avPlayer = AVPlayer(url: videoURL)
        avPlayerLayer = AVPlayerLayer(player: avPlayer)
        avPlayerLayer.videoGravity = AVLayerVideoGravity.resizeAspect
        avPlayer?.actionAtItemEnd = .none
        videoBackView.layer.addSublayer(avPlayerLayer)
        avPlayerLayer.frame = videoBackView.layer.bounds
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerEnd), name: .AVPlayerItemDidPlayToEndTime, object: avPlayer!.currentItem)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.avPlayer?.play()
        }
    }

    @objc func playerEnd() {
        LocalStore.onBoarding = true
        ViewHierarchyWorker.setRootViewController(rootViewController: MasterViewController.instantiate(fromStoryboard: .main))
        dismiss(animated: true, completion: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }

}
