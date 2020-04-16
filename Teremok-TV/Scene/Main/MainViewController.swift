//
//  MainViewController.swift
//  Teremok-TV
//
//  Created by R9G on 22.08.2018.
//  Copyright (c) 2018 xmedia. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import AVFoundation


protocol MainDisplayLogic: CommonDisplayLogic {
    func display(razdels: [Main.RazdelItem])
    func seriesDisplay(indexPath: IndexPath, show: [MainContent])
}

class MainViewController: AbstractMainViewController, MainDisplayLogic {
    var activityView: LottieHUD?
    
    var interactor: MainBusinessLogic?
    var router: (NSObjectProtocol & MainRoutingLogic & MainDataPassing & CommonRoutingLogic)?
    
    var modallyControllerRoutingLogic: CommonRoutingLogic? {
        get { return router }
    }
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
        let interactor = MainInteractor()
        let presenter = MainPresenter()
        let router = MainRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }

    @IBOutlet private var mainTitleViewTopConstraint: NSLayoutConstraint!
    @IBOutlet private var mainTitleView: MainTitleView!
    @IBOutlet private var collectionView: UICollectionView!
    
    var razdels: [Main.RazdelItem] = []
    var extendedRazdels: [IndexPath : [MainContent]] = [:]
    
    var cellWidth: CGFloat = 0
    var audioPlayer: AVAudioPlayer?
    var buttonPlayer: AVAudioPlayer?

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
       
        mainTitleViewTopConstraint.constant = titleTopConstaraintCalculate()
        
        prepareUI()
        fetchRazdels()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       if ServiceConfiguration.activeConfiguration() == .prod  {
            audioPlayer?.play()
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        audioPlayer?.stop()
    }

    private func prepareUI(){
        activityView = LottieHUD()
        collectionView.delegate = self
        let cells = [RedesignedMainCollectionViewCell.self, ExtendedMainCollectionViewCell.self]
        collectionView.register(cells: cells)
        collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        cellWidth = view.bounds.width/3.2

        let backSound = BackgroundMediaWorker.getSound()

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: backSound)
            audioPlayer?.numberOfLoops = 5
        } catch {
            print("no file \(backSound)")
        }
        let buttonSound = URL(fileURLWithPath: Bundle.main.path(forResource: "push_level_up", ofType: "mp3")!)

        do {
            buttonPlayer = try AVAudioPlayer(contentsOf: buttonSound)
            buttonPlayer?.prepareToPlay()
        } catch {
            print("no file \(buttonSound)")
        }
    }

    func didSelectSoundPlay(){
        audioPlayer?.stop()
        buttonPlayer?.play()
    }

    // MARK: Do something
    
    func fetchRazdels(){
        showPreloader()
        interactor?.getMainContent()
    }
    
    func display(razdels: [Main.RazdelItem]) {
        hidePreloader()
        self.razdels = razdels
        collectionView.reloadData()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var visibleRect = CGRect()
        
        visibleRect.origin = collectionView.contentOffset
        visibleRect.size = collectionView.bounds.size
        
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        
        guard let indexPath = collectionView.indexPathForItem(at: visiblePoint) else { return }
        if indexPath.section == 0 {
            mainTitleView.configureTitle(title: "Развивающие игры")
        } else {
            mainTitleView.configureTitle(title: razdels[indexPath.row].title)
        }
    }
    
    func seriesDisplay(indexPath: IndexPath, show: [MainContent]) {
        extendedRazdels[indexPath] = show
        collectionView.reloadItems(at: [indexPath])
    }
}

extension MainViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectSoundPlay()
		if indexPath.section == 0 {
			router?.navigateToGameList()
		} else {
            if !extendedRazdels.keys.contains(indexPath) {
                let razdelItem = router?.dataStore?.mainRazdels[safe: indexPath.row]
                if let type = razdelItem?.itemType, type == .series {
                    interactor?.getSeriesRazdelContent(razdelId: razdelItem?.razdId ?? 0, indexPath: indexPath)
                } else {
                    interactor?.getVideoContent(id: razdelItem?.razdId ?? 0, indexPath: indexPath)
                }
            }
		}
    }
}

extension MainViewController: UICollectionViewDataSource {
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		2
	}
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return section == 0 ? 1 : razdels.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let razdelItem = router?.dataStore?.mainRazdels[safe: indexPath.row]
        if extendedRazdels.keys.contains(indexPath) {
            let cell = collectionView.dequeueReusableCell(withCell: ExtendedMainCollectionViewCell.self, for: indexPath)
            cell.serials = extendedRazdels[indexPath] ?? []
            cell.razdelNumber = indexPath.row
            cell.delegate = self
            if let type = razdelItem?.itemType, type == .videos {
                cell.videosCell = true
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withCell: RedesignedMainCollectionViewCell.self, for: indexPath)
                       
            if indexPath.section == 0 {
                cell.gameRazdelConfigure()
            } else {
                //TO DO:
                cell.configure(title: razdels[indexPath.row].title, imagesURLs: razdels[indexPath.row].topImagesURLs)
            }

            return cell
        }
    }
}
extension MainViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: cellWidth, height: collectionView.bounds.height)
    }
}

extension MainViewController: DidSelectRazdelAt {
    func present(title: String, actions: [UIAlertAction]) {
        present(title: title, actions: actions, completion: nil)
    }
    
    func addVideoToFavorite(videoId: Int) {
        self.interactor?.addToFav(videoId: videoId)
    }
    
    func downloadVideo(video: Serial.Item, completion: @escaping (Bool) -> ()) {
        self.interactor?.downloadVideo(video: video, completion: completion)
    }
    
    func goToSerial(razdel: Int, title: String) {
        self.router?.navigateToVideos(razdelId: razdel, title: title)
    }
    
    func goToRazdel(razdel: Int) {
        self.router?.navigateToRazdel(number: razdel)
    }
    
    func goToPreview(razdelId: Int, videoId: Int) {
        if Profile.current?.premium ?? false {
            self.router?.navigateToPreview(razdelId: razdelId, videoId: videoId)
        } else {
            self.router?.openPremiumAlert()
        }
    }
}
