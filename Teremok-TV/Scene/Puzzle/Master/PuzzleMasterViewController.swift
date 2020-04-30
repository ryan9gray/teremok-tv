//
//  PuzzleMasterViewController.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 22.03.2020.
//  Copyright (c) 2020 xmedia. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import AVKit
import Trackable

protocol PuzzleMasterDisplayLogic: MasterModuleDisplayLogic, TrackableClass {
    
}

class PuzzleMasterViewController: GameMasterViewController, PuzzleMasterDisplayLogic {
    var interactor: PuzzleMasterBusinessLogic?
    var router: (CommonRoutingLogic & PuzzleMasterRoutingLogic & PuzzleMasterDataPassing)?
    var modallyControllerRoutingLogic: CommonRoutingLogic? {
        get { return router }
    }
    var activityView: LottieHUD?

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
        let interactor = PuzzleMasterInteractor()
        let presenter = PuzzleMasterPresenter()
        let router = PuzzleMasterRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }

    // MARK: View lifecycle
	@IBAction private func homeClick(_ sender: Any) {
		if router?.canPop() ?? false {
			router?.popChild()
		} else {
			dismiss(animated: true, completion: nil)
		}
	}
	
	private var navigationSubscription: Subscription?

    override func viewDidLoad() {
        super.viewDidLoad()

		homeBtn.gradientColors = [ UIColor.PuzzleGame.blueOne, UIColor.PuzzleGame.blueTwo ]
		router?.navigateMain()
		navigationSubscription = router?.subscribeForNavigation { [weak self] canPop in
			self?.homeBtn.setImage(canPop ? UIImage(named: "icBackShadow") : UIImage(named: "icHomeShadow"), for: .normal)
		}
		setupTrackableChain(parent: analytics)
    }

    // MARK: Actions
	deinit {
		track(
			Events.Time.PuzzleFlow,
			trackedProperties: [Keys.Timer  ~>> NSDate().timeIntervalSince(startTime)]
		)
		if ServiceConfiguration.activeConfiguration().logging {
			print("Logger: deinit \(className)")
		}
	}
}
