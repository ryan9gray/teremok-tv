//
//  DinoMasterViewController.swift
//  Teremok-TV
//
//  Created by Виктор Пузаков on 06.04.2020.
//  Copyright © 2020 xmedia. All rights reserved.
//

import UIKit
import AVKit
import Trackable

protocol DinoMasterDisplayLogic: MasterModuleDisplayLogic, TrackableClass {
    
}

class DinoMasterViewController: GameMasterViewController, DinoMasterDisplayLogic {
    var interactor: DinoMasterBusinessLogic?
    var router: (CommonRoutingLogic & DinoMasterRoutingLogic & DinoMasterDataPassing)?
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
        let interactor = DinoMasterInteractor()
        let presenter = DinoMasterPresenter()
        let router = DinoMasterRouter()
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
        homeBtn.gradientColors = Style.Gradients.DinoGame.green.value
        
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
            Events.Time.MonsterFlow,
            trackedProperties: [Keys.Timer  ~>> NSDate().timeIntervalSince(startTime)]
        )
        if ServiceConfiguration.activeConfiguration().logging {
            print("Logger: deinit \(className)")
        }
    }
}

extension DinoMasterViewController: EasyTipViewDelegate {
    func easyTipViewDidDismiss(_ tipView: EasyTipView) {
        tipView.dismiss()
    }
}
