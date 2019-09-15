//
//  TTPlayerViewController.swift
//  Teremok-TV
//
//  Created by R9G on 24/08/2018.
//  Copyright © 2018 xmedia. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
//import GoogleInteractiveMediaAds

protocol AVPlayerOverlayVCDelegate: class {
    func avPlayerOverlay(_ vc: TTPlayerViewController, didFullScreen sender: Any?)
    func avPlayerOverlay(_ vc: TTPlayerViewController, didNormalScreen sender: Any?)
    func avPlayerOverlay(_ vc: TTPlayerViewController, periodicTimeObserver time: CMTime)
    func avPlayerOverlay(_ vc: TTPlayerViewController, statusReadyToPlay sender: Any?)
    func avPlayerOverlay(_ vc: TTPlayerViewController, didCloseAll sender: Any?)
    func avPlayerOverlay(_ vc: TTPlayerViewController, download sender: Any?)
    func avPlayerOverlay(_ vc: TTPlayerViewController, like sender: Any?)
    func avPlayerOverlay(_ vc: TTPlayerViewController, reklam sender: Any?)
    func avPlayerOverlay(_ vc: TTPlayerViewController, endPlay sender: Any?)
}

class TTPlayerViewController: UIViewController, UIGestureRecognizerDelegate {
    @IBOutlet var heartButton: TTAbstractMainButton!
    @IBOutlet var descriptionLbl: UILabel!
    @IBOutlet var playButton: TTAbstractMainButton!
    @IBOutlet var fullscreenButton: TTAbstractMainButton!
    @IBOutlet var downloadButton: TTAbstractMainButton!
    @IBOutlet var timeLbl: UILabel!
    @IBOutlet var playerSlider: TTPlayerSlider!
    @IBOutlet var bottomView: UIView!
    var isFullScreen = false
    open fileprivate(set) var playerItem : AVPlayerItem?

    fileprivate var timer : Timer = {
        let time = Timer()
        return time
    }()

    @IBAction func downloadClick(_ sender: UIButton) {
        toNormalScreen()
        sender.isSelected.toggle()
        delegate?.avPlayerOverlay(self, download: sender)
    }
    @IBAction func heartClick(_ sender: UIButton) {
        sender.isSelected.toggle()
        delegate?.avPlayerOverlay(self, like: sender)
    }

    private var timeObserver: Any?
    var totalDuration : TimeInterval = 0.0
    var currentDuration : TimeInterval = 0.0

    var player: AVPlayer? {
        didSet{
            
        }
    }
    var playerLayer: AVPlayerLayer!
    @IBOutlet private var hud: UIActivityIndicatorView!
    
    
    weak var delegate: AVPlayerOverlayVCDelegate?
    var isOffline = false {
        didSet{
            toOffline(its: isOffline)
        }
    }
    
    func toOffline(its: Bool){
    
        downloadButton.isHidden = its
        heartButton.isHidden = its
    }

    private var playerItemContext = 0

    @IBAction func playClick() {
        if player?.rate == 0 {
            play()
        } else {
            pause()
        }
    }
    func play() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: .moviePlayback)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
        }
        catch {
            // report for an error
        }
        player?.play()
        playButton.setImage(#imageLiteral(resourceName: "icPause"), for: .normal)
        stopTimer()
        startTimer()
    }
    func pause() {
        guard let player = player else { return }
        player.pause()
        playButton.setImage(#imageLiteral(resourceName: "icPlay"), for: .normal)
        stopTimer()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        isPremium = Profile.current?.premium ?? false
    }

    var isPremium = false
    
    func startedPlaying(){
        toFullScreen()
    }
    
    func setPlayer(_ newPlayer: AVPlayer){
        hud.stopAnimating()
        stopTimer()
        player = newPlayer
        playerItem = newPlayer.currentItem
        addPlayerObservers()
        play()
        addPlayerNotifications()
        addPlayerItemObservers()
    }

    private func setUI(){
        mainWindow = UIApplication.shared.keyWindow
        addGesture()
        playerSlider.addTarget(self, action: #selector(self.handlePlayheadSliderTouchBegin), for: .touchDown)
        playerSlider.addTarget(self, action:    #selector(self.handlePlayheadSliderTouchEnd), for: .touchUpInside)
        playerSlider.addTarget(self, action: #selector(self.handlePlayheadSliderValueChanged), for: .valueChanged)
        
        fullscreenButton.addTarget(self, action: #selector(self.didFullscreenButtonSelected(_:)), for: .touchUpInside)
        downloadButton.addTarget(self, action: #selector(self.downloadClick(_:)), for: .touchUpInside)
        playButton.addTarget(self, action: #selector(self.playClick), for: .touchUpInside)
        heartButton.addTarget(self, action: #selector(self.heartClick), for: .touchUpInside)
    }

    
    var mainParent: UIViewController?
    var originalFrame: CGRect?
    var currentFrame: CGRect?
    var mainWindow: UIWindow?
    var containerView: UIView?
    var window: UIWindow?
    
    @IBAction  func didFullscreenButtonSelected(_ sender: Any){
        if !isFullScreen {
            toFullScreen()
        }
        else {
            toNormalScreen()
        }
    }
    
    private func toFullScreen(){
        guard !isFullScreen else {
            return
        }
        isFullScreen = true
        
        if mainWindow == nil {
               mainWindow = UIApplication.shared.keyWindow
        }
        guard let parent = self.parent else { return }

        if window == nil {
            originalFrame = parent.view.frame
            mainParent = parent.parent
            currentFrame = parent.view.convert(parent.view.frame, from: mainWindow)
            containerView = parent.view.superview
            
            parent.removeFromParent()
            parent.view.removeFromSuperview()
            parent.willMove(toParent: nil)
            window = UIWindow(frame: currentFrame!)

            window?.backgroundColor = .black
            window?.windowLevel = .normal
            window?.makeKeyAndVisible()
            window?.rootViewController = parent
            parent.view.frame = window?.bounds ?? view.bounds
            delegate?.avPlayerOverlay(self, didFullScreen: nil)

            UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: .calculationModeCubic, animations: { [weak self] in
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.25) {
                    self?.window?.frame = (self?.mainWindow?.bounds)!
                }
            })
            setControls(isFull: isFullScreen)
        }
    }

    private func toNormalScreen() {
        guard isFullScreen else {
            return
        }
        isFullScreen = false
        guard let parent = self.parent else { return }

        self.window?.frame = (self.mainWindow?.bounds)!
        delegate?.avPlayerOverlay(self, didNormalScreen: nil)
        
        UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: .layoutSubviews, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.25) {
                parent.view.removeFromSuperview()
                self.window?.rootViewController = nil
                self.mainParent?.addChild(parent)
                self.containerView?.addSubview(parent.view)
                parent.view.frame = self.originalFrame ?? parent.view.frame
                parent.didMove(toParent: self.mainParent)
                self.mainWindow?.makeKeyAndVisible()
                self.containerView = nil
                self.mainParent = nil
                self.window = nil
            }
        })
        setControls(isFull: isFullScreen)
    }
    
    func setControls(isFull: Bool) {
        fullscreenButton.isSelected = isFull
    }

    @IBAction func handlePlayheadSliderTouchBegin(_ sender: UISlider) {
        pause()
        stopTimer()
    }
    @IBAction func handlePlayheadSliderValueChanged(_ sender: UISlider) {
        guard let duration : CMTime = (player?.currentItem?.asset.duration) else { return }
        let seconds : Float64 = CMTimeGetSeconds(duration) * Double(sender.value)
        timeLbl.text = PlayerHelper.stringFromTimeInterval(seconds)
    }
    @IBAction func handlePlayheadSliderTouchEnd(_ sender: UISlider) {
        
        if player?.status == .readyToPlay {
            guard let duration : CMTime = (player?.currentItem?.asset.duration) else { return }
            let newCurrentTime: TimeInterval = Double(sender.value) * CMTimeGetSeconds(duration)
            let seekToTime: CMTime = CMTimeMakeWithSeconds(newCurrentTime, preferredTimescale: 100)
            print(seekToTime)
            player?.seek(to: seekToTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
        }
        startTimer()
        play()
    }

    internal func addGesture() {
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(onSingleTapGesture(_:)))
        singleTapGesture.numberOfTapsRequired = 1
        singleTapGesture.numberOfTouchesRequired = 1
        singleTapGesture.delegate = self
        view.addGestureRecognizer(singleTapGesture)
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(onDoubleTapGesture(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        doubleTapGesture.numberOfTouchesRequired = 1
        doubleTapGesture.delegate = self
        view.addGestureRecognizer(doubleTapGesture)
        singleTapGesture.require(toFail: doubleTapGesture)
        
    }
    
    @objc open func onSingleTapGesture(_ gesture: UITapGestureRecognizer) {
        setPlayBottomViewAnimation()
    }
    @objc open func onDoubleTapGesture(_ gesture: UITapGestureRecognizer) {
        didFullscreenButtonSelected(gesture)
    }

    open func playerDurationDidChange(_ currentDuration: TimeInterval, totalDuration: TimeInterval) {
        let current = PlayerHelper.stringFromTimeInterval(currentDuration)
        timeLbl.text = "\(current + " / " +  (PlayerHelper.stringFromTimeInterval(totalDuration)))"
        playerSlider.value = Float(currentDuration / totalDuration)
    }

    fileprivate func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(setPlayBottomViewAnimation), userInfo: nil, repeats: false)
    }
    fileprivate func stopTimer() {
        timer.invalidate()
    }

    @objc fileprivate func setPlayBottomViewAnimation() {
        if bottomView.alpha == 0 {
            displayControlAnimation()
        } else {
            hiddenControlAnimation()
        }
    }
    
    internal func displayControlAnimation() {
        bottomView.isHidden = false
        UIView.animate(withDuration: 0.5, animations: {
            self.bottomView.alpha = 1
        }) { (completion) in
            self.startTimer()
        }
    }
    internal func hiddenControlAnimation() {
        stopTimer()
        UIView.animate(withDuration: 0.5, animations: {
            self.bottomView.alpha = 0
        }) { (completion) in
            self.bottomView.isHidden = true
        }
    }
    
    // time KVO
    
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        // Only handle observations for the playerItemContext
        guard context == &playerItemContext else {
            super.observeValue(forKeyPath: keyPath,
                               of: object,
                               change: change,
                               context: context)
            return
        }
        if keyPath == #keyPath(AVPlayerItem.status) {
            let status: AVPlayerItem.Status
            if let statusNumber = change?[.newKey] as? NSNumber {
                status = AVPlayerItem.Status(rawValue: statusNumber.intValue)!
            } else {
                status = .unknown
            }

            // Switch over status value
            switch status {
            case .readyToPlay: break
            // Player item is ready to play.
            case .failed: break
            // Player item failed. See error.
            case .unknown: break
                // Player item is not yet ready.
            @unknown default:
                break
            }
        }
        if(keyPath == "playbackBufferEmpty") {
            print("Buffer Empty")
            //pause()
        }
        else if keyPath == "playbackLikelyToKeepUp" {
            print("Keep Up")
            //play()

        }
        else if keyPath == "playbackBufferFull" {
            print("Buffer Full")

        }
    }
    
    func addPlayerObservers() {
        removePlayerObservers()
        timeObserver = player?.addPeriodicTimeObserver(forInterval: .init(value: 1, timescale: 1), queue: DispatchQueue.main, using: { [weak self] time in
            guard let strongSelf = self else { return }
            if let currentTime = strongSelf.player?.currentTime().seconds, let totalDuration = strongSelf.player?.currentItem?.duration.seconds {
                strongSelf.currentDuration = currentTime
                strongSelf.playerDurationDidChange(currentTime, totalDuration: totalDuration)
                strongSelf.delegate?.avPlayerOverlay(strongSelf, periodicTimeObserver: time)
            }
        })
    }
    internal func removePlayerObservers() {
        if timeObserver != nil {
            player?.removeTimeObserver(timeObserver!)
            timeObserver = nil
        }
    }
    deinit {
        stopTimer()
        delegate = nil
        containerView = nil
        mainParent = nil
        window?.removeFromSuperview()
        window = nil;
        mainWindow?.makeKeyAndVisible()
        
        removePlayerObservers()
        removePlayerItemObservers()
        removePlayerNotifations()
        player = nil
    }
    

    @objc func playerEnd(){
        delegate?.avPlayerOverlay(self, endPlay: player)
    }
}

extension TTPlayerViewController {
    internal func addPlayerItemObservers() {
        let options = NSKeyValueObservingOptions([.new])
        playerItem?.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), options: options, context: &playerItemContext)
        playerItem?.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.loadedTimeRanges), options: options, context: &playerItemContext)
        playerItem?.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.isPlaybackLikelyToKeepUp), options: options, context: &playerItemContext)
        playerItem?.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.isPlaybackBufferFull), options: options, context: &playerItemContext)
        playerItem?.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.playbackBufferEmpty), options: options, context: &playerItemContext)


    }
    internal func addPlayerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerEnd), name: .AVPlayerItemDidPlayToEndTime, object: player!.currentItem)
        NotificationCenter.default.addObserver(self, selector: .applicationWillEnterForeground, name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: .applicationDidEnterBackground, name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    internal func removePlayerItemObservers() {
        
        playerItem?.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.status))
        playerItem?.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.loadedTimeRanges))
        playerItem?.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.playbackBufferEmpty))
        playerItem?.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.isPlaybackLikelyToKeepUp))
        playerItem?.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.isPlaybackBufferFull))
    }
    
    internal func removePlayerNotifations() {
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    @objc internal func applicationDidEnterBackground(_ notification: Notification) {
        pause()
    }
    @objc internal func applicationWillEnterForeground(_ notification: Notification) {
        play()
    }
}
