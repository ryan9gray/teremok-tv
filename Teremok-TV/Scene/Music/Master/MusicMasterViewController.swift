//
//  MusicMasterViewController.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 16/03/2019.
//  Copyright (c) 2019 xmedia. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import AVFoundation
import MediaPlayer
import Trackable

protocol MusicMasterDisplayLogic: CommonDisplayLogic, TrackableClass {
    func showMain()
    func canBack()
    func play(type: MusicMaster.ItemType, isNew: Bool)
    func pauseTrack()
    var type: MusicMaster.ItemType? { get }
    func openSettings()
    func openAutorization()
}

class MusicMasterViewController: UIViewController, MusicMasterDisplayLogic {
    var modallyControllerRoutingLogic: CommonRoutingLogic?
    var activityView: LottieHUD?
    var interactor: MusicMasterBusinessLogic?
    var router: (NSObjectProtocol & MusicMasterRoutingLogic & MusicMasterDataPassing & CommonRoutingLogic)?

    // MARK: Object lifecycle

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: Setup

    private func setup() {
        let viewController = self
        let interactor = MusicMasterInteractor()
        let presenter = MusicMasterPresenter()
        let router = MusicMasterRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        UILabel.appearance().textColor = UIColor.Base.darkBlue
        showMain()

        //LockScreen Media control registry
        if UIApplication.shared.responds(to: #selector(UIApplication.beginReceivingRemoteControlEvents)){
            UIApplication.shared.beginReceivingRemoteControlEvents()
            UIApplication.shared.beginBackgroundTask(expirationHandler: { () -> Void in

            })
        }
        playerSlider.addTarget(self, action: #selector(self.handlePlayheadSliderTouchBegin), for: .touchDown)
        playerSlider.addTarget(self, action:    #selector(self.handlePlayheadSliderTouchEnd), for: .touchUpInside)
        playerSlider.addTarget(self, action: #selector(self.handlePlayheadSliderValueChanged), for: .valueChanged)
        NotificationCenter.default.addObserver(self, selector: #selector(self.didPlayToEnd), name: .AVPlayerItemDidPlayToEndTime, object: nil)
        setupSlider()
        controlView.isUserInteractionEnabled = false
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.changePlaybackPositionCommand.isEnabled = true
        commandCenter.changePlaybackPositionCommand.addTarget(self, action: #selector(changePlaybackPositionCommand(_:)))
        commandCenter.nextTrackCommand.addTarget { [weak self] event in
            guard let self = self else { return .commandFailed }

            self.nextTrack()
            return .success
        }
        commandCenter.previousTrackCommand.addTarget { [weak self] event in
            guard let self = self else { return .commandFailed }

            self.previuse()
            return .success
        }
        commandCenter.playCommand.addTarget { [weak self] event in
            guard let self = self else { return .commandFailed }

            self.playTrack()
            return .success
        }
        commandCenter.pauseCommand.addTarget { [weak self] event in
            guard let self = self else { return .commandFailed }

            self.pauseTrack()
            return .success
        }

    }

    @IBOutlet var backgroundView: UIImageView!
    @IBOutlet private var homeBtn: BadgeButton!
    @IBOutlet private var searchBtn: BadgeButton!
    @IBOutlet private var titleLbl: UILabel!
    @IBOutlet private var albumLbl: UILabel!
    @IBOutlet private var timeLbl: UILabel!
    @IBOutlet private var downBtn: UIButton!
    @IBOutlet private var heartBtn: UIButton!
    @IBOutlet private var repeatBtn: UIButton!
    @IBOutlet private var shuflBtn: UIButton!
    @IBOutlet private var playButton: UIButton!
    @IBOutlet private var playerSlider: TTPlayerSlider!
    @IBOutlet private var backwardBtn: UIButton!
    @IBOutlet private var forwardBtn: UIButton!
    @IBOutlet private var totalTimeLbl: UILabel!
    @IBOutlet private var controlView: UIView!
    @IBOutlet private var backNavBtn: BadgeButton!
    @IBOutlet private var actionsStackView: UIStackView!
    var player: AVPlayer? = nil
    let startTime = Date()
    var output: Output!

    struct Output {
        var openSettings: () -> Void
        var openAuthorization: () -> Void
    }
    func openSettings() {
        self.dismiss(animated: true) {
            self.output.openSettings()
        }
    }
    func openAutorization() {
        self.dismiss(animated: true) {
            self.output.openAuthorization()
        }
    }
    
    var currentAudioPath: URL? {
        didSet {
            if let url = currentAudioPath {
                play(url: url)
            }
        }
    }
    var shuffleState = false {
        didSet {
            shuflBtn.isSelected = shuffleState
        }
    }
    var repeatState = false {
        didSet {
            repeatBtn.isSelected = repeatState
        }
    }
    var index: Int = Int()
    private var timeObserver: Any?

    var type: MusicMaster.ItemType?
    var album: MusicPlaylistResponse?
    var playlist: [MusicPlaylistItemResponse] {
        return album?.items ?? []
    }
    var track: MusicPlaylistItemResponse? {
        return playlist[safe: index]
    }
    var offlinePlaylist: [MusicMaster.OfflineMusicModel] = []
    var offlineTrack: MusicMaster.OfflineMusicModel? {
        return offlinePlaylist[safe: index]
    }

    @IBAction func backNavClick(_ sender: Any) {
        router?.popChild()
    }
    @IBAction func searchClick(_ sender: UIButton) {
        router?.navigateToSearch()
    }
    @IBAction func homeClick(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func playClick(_ sender: UIButton) {
        if player?.rate == 0 {
            playTrack()
        } else {
            pauseTrack()
        }
    }
    @IBAction func backwardClick(_ sender: UIButton) {
        previuse()
    }
    @IBAction func forwardClick(_ sender: UIButton) {
        nextTrack()
    }
    @IBAction func shuflClick(_ sender: UIButton) {
        shuffleState.toggle()
    }
    @IBAction func repeatClick(_ sender: UIButton) {
        repeatState.toggle()
    }
    @IBAction func heartClick(_ sender: UIButton) {
        guard let id = track?.id else { return }

        track?.inFavorites.toggle()
        heartBtn.isSelected.toggle()
        interactor?.toFav(id: id)
    }
    @IBAction func downClick(_ sender: UIButton) {
        guard BackgroundSession.shared.list.count < 5 else { return }
        
        if !(track?.downloadMe ?? false) {
            track?.downloadMe = true
            downBtn.isSelected = true
            interactor?.toDownload(index: index)
        }
    }
    @IBAction func handlePlayheadSliderTouchBegin(_ sender: UISlider) {
        pauseTrack()
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
        playTrack()
    }

    func setupSlider() {
        guard
            let gradientImage = UIImage.gradientImage(
            with: playerSlider.frame,
            colors: [ UIColor.Button.yellowOne.cgColor, UIColor.Button.yellowTwo.cgColor ],
            locations: nil
            ) else
        { return }

        playerSlider.setMinimumTrackImage(gradientImage, for: .normal)
    }
    func showMain() {
        router?.navigateMain()
    }
    func canBack() {
        backNavBtn.isHidden = !(router?.canPop() ?? false)
    }

    func play(type: MusicMaster.ItemType, isNew: Bool) {
        self.type = type
        var interactive = true
        switch type {
        case .offline(idx: let idx, models: let items):
            if !isNew, sameIndex(idx: idx) { return }
            album = nil
            offlinePlay(items: items, idx: idx)
            interactive = false
        case .online(idx: let idx, playlist: let response):
            if !isNew, sameIndex(idx: idx) { return }
            offlinePlaylist = []
            play(album: response, idx: idx, isNew: isNew)
        }
        controlView.isUserInteractionEnabled = true
        heartBtn.isUserInteractionEnabled = interactive
        downBtn.isUserInteractionEnabled = interactive
    }

    func sameIndex(idx: Int) -> Bool {
        if index == idx {
            playTrack()
            return true
        }
        return false
    }

    func offlinePlay(items: [MusicMaster.OfflineMusicModel], idx: Int) {
        offlinePlaylist = items
        index = idx
        playIndex()
        interactor?.listenAction(id: offlineTrack?.id ?? 0)
    }

    func play(album: MusicPlaylistResponse, idx: Int, isNew: Bool) {
        if isNew { self.album = album }
        index = idx
        interactor?.setPLaylist(album)
        playIndex()
        interactor?.listenAction(id: track?.id ?? 0)
    }

    // MARK: MusicPlayer

    func play(url: URL) {
        let playerAsset = AVURLAsset(url: url, options: .none)
        var playerItem: AVPlayerItem

        if url.absoluteString.hasPrefix("file:///") {
            let keys = ["tracks", "playable"];
            playerItem = AVPlayerItem(asset: playerAsset, automaticallyLoadedAssetKeys: keys)
        }
        else{
            playerItem = AVPlayerItem(asset: playerAsset)
        }
        do {
            //Preparation to play
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: .moviePlayback)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
        }
        catch {
            // report for an error
        }
        if player != nil {
            player?.replaceCurrentItem(with: playerItem)
        }
        else {
            player = AVPlayer(playerItem: playerItem)
        }
        addPlayerObservers()
        UIApplication.shared.beginReceivingRemoteControlEvents()
        playTrack()
    }

    @objc func didPlayToEnd() {
        nextTrack()
    }
    @objc func nextTrack() {
        guard playCondition() else { return }

        let count = offlinePlaylist.count + playlist.count
        if(index < count - 1) {
            index = index + 1
        } else {
            index = 0
        }
        playIndex()
    }

    @objc func previuse() {
        guard playCondition() else { return }

        if(index > 0){
            index = index - 1
            playIndex()
        }
    }
    func playCondition() -> Bool {
        if repeatState {
            playIndex()
            return false
        }
        if shuffleState {
            let count = UInt32(offlinePlaylist.count + playlist.count)
            index = Int(arc4random_uniform(count))
            print("\(count) \(index)")
            playIndex()
            return false
        }
        return true
    }

    func playIndex() {
        guard let type = self.type else { return }

        swichTrack()
        switch type {
        case .offline:
            currentAudioPath = offlineTrack?.url
            showMediaInfo(name: offlineTrack?.name ?? "", artist: offlineTrack?.albumName ?? "")
        case .online:
            currentAudioPath = URL(string: track?.link ?? "")
            downBtn.isSelected = track?.downloadMe ?? false
            heartBtn.isSelected = track?.inFavorites ?? false
            showMediaInfo(name: track?.name ?? "", artist: track?.album?.name ?? "")
        }
    }
    
    @objc func playTrack() {
        player?.play()
        playButton.setImage(#imageLiteral(resourceName: "icPause48"), for: .normal)
    }

    @objc func pauseTrack() {
        guard let player = player else { return }
        player.pause()
        playButton.setImage(#imageLiteral(resourceName: "icPlay48"), for: .normal)
    }

    func swichTrack() {
        let id: Int
        switch type {
        case .some(.online):
            id = album?.id ?? 0
        case .some(.offline):
            id = 0
        default:
            id = 0
        }
        NotificationCenter.default.post(name: .SwichTrack, object: index, userInfo: ["id": id])
    }

    func showMediaInfo(name: String, artist: String) {
        albumLbl.text = name
        titleLbl.text = artist

        var nowPlayingInfo: [String : Any] = [MPMediaItemPropertyArtist : artist,  MPMediaItemPropertyTitle : name]
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = player?.currentItem?.currentTime().seconds
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = player?.currentItem?.asset.duration.seconds
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = player?.rate
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    open func playerDurationDidChange(_ currentDuration: TimeInterval, totalDuration: TimeInterval) {
        let current = PlayerHelper.stringFromTimeInterval(currentDuration)
        timeLbl.text = "\(current)"
        totalTimeLbl.text = "\((PlayerHelper.stringFromTimeInterval(totalDuration)))"
        playerSlider.value = Float(currentDuration / totalDuration)
    }

    @objc func changePlaybackPositionCommand(_ event: MPChangePlaybackPositionCommandEvent) -> MPRemoteCommandHandlerStatus{
        let cmTime = CMTimeMakeWithSeconds(event.positionTime, preferredTimescale: 1000000)
        player?.seek(to: cmTime)
        return MPRemoteCommandHandlerStatus.success;
    }
    func addPlayerObservers() {
        removePlayerObservers()
        timeObserver = player?.addPeriodicTimeObserver(
            forInterval: .init(value: 1, timescale: 1),
            queue: DispatchQueue.main,
            using: { [weak self] time in
                guard let strongSelf = self else { return }
                if let currentTime = strongSelf.player?.currentTime().seconds, let totalDuration = strongSelf.player?.currentItem?.duration.seconds {
                    strongSelf.playerDurationDidChange(currentTime, totalDuration: totalDuration)
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
        track(
            Events.Time.MusicFlow,
            trackedProperties: [Keys.Timer  ~>> NSDate().timeIntervalSince(startTime)]
        )
        if ServiceConfiguration.activeConfiguration().logging {
            print("Logger: deinit \(self.debugDescription)")
        }
        removePlayerObservers()
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
        player = nil
        BackgroundMediaWorker.setText()
        do {
            //Preparation to play
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.ambient, mode: .moviePlayback)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
        }
        catch {
            // report for an error
        }
    }
}
