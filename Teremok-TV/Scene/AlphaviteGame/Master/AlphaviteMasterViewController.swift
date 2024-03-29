//
//  AlphaviteMasterViewController.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 01/08/2019.
//  Copyright (c) 2019 xmedia. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import AVKit
import Trackable

protocol AlphaviteMasterDisplayLogic: MasterModuleDisplayLogic, TrackableClass {
    
}

class AlphaviteMasterViewController: GameMasterViewController, AlphaviteMasterDisplayLogic {
    var interactor: AlphaviteMasterBusinessLogic?
    var router: (CommonRoutingLogic & AlphaviteMasterRoutingLogic & AlphaviteMasterDataPassing)?
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
        let interactor = AlphaviteMasterInteractor()
        let presenter = AlphaviteMasterPresenter()
        let router = AlphaviteMasterRouter()
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

        navigationSubscription = router?.subscribeForNavigation { [weak self] canPop in
            self?.homeBtn.setImage(canPop ? UIImage(named: "icBackShadow") : UIImage(named: "icHomeShadow"), for: .normal)
        }
        interactor?.onDemand { [weak self] success in
            DispatchQueue.main.async {
            if success {
                self?.router?.navigateMain()
            } else {
                self?.present(errorString: "Игра загружается, попробуйте позже") {
                    self?.dismiss(animated: true)
                }
            }
            }
        }
        setupTrackableChain(parent: analytics)
    }

    deinit {
        track(
            Events.Time.AlphabetFlow,
            trackedProperties: [Keys.Timer  ~>> NSDate().timeIntervalSince(startTime)]
        )
        if ServiceConfiguration.activeConfiguration().logging {
            print("Logger: deinit \(className)")
        }
    }
}

extension AlphaviteMasterViewController: EasyTipViewDelegate {
    func easyTipViewDidDismiss(_ tipView: EasyTipView) {
        tipView.dismiss()
    }
}
