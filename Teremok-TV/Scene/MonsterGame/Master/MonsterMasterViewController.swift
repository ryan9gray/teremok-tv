//
//  MonsterMasterViewController.swift
//  Teremok-TV
//
//  Created by Дмитрий Грищенко on 14/08/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

import UIKit
import AVKit
import Trackable

protocol MonsterMasterDisplayLogic: MasterModuleDisplayLogic, TrackableClass {
    
}

class MonsterMasterViewController: GameMasterViewController, MonsterMasterDisplayLogic {
    var interactor: MonsterMasterBusinessLogic?
    var router: (CommonRoutingLogic & MonsterMasterRoutingLogic & MonsterMasterDataPassing)?
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
        let interactor = MonsterMasterInteractor()
        let presenter = MonsterMasterPresenter()
        let router = MonsterMasterRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: View lifecycle

    @IBAction func avatarClick(_ sender: Any) {
        tipView?.dismiss()
        router?.openStatistic()
    }
    
    @IBAction private func homeClick(_ sender: Any) {
        if router?.canPop() ?? false {
            router?.popChild()
        } else {
            dismiss(animated: true, completion: nil)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        displayProfile()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !avatarButton.isHidden, LocalStore.monsterTip < 3 {
            LocalStore.monsterTip += 1
            var preferences = EasyTipView.Preferences()
            preferences.drawing.font = Style.Font.istokWeb(size: 16)
            preferences.drawing.foregroundColor = UIColor.View.titleText
            preferences.drawing.backgroundColor = .white
            preferences.drawing.arrowPosition = EasyTipView.ArrowPosition.right
            tipView = EasyTipView(text: "Здесь можно посмотреть статистику", preferences: preferences, delegate: self)
            tipView?.show(animated: true, forView: avatarButton, withinSuperview: view)
        }
    }

    deinit {
        track(
            Events.Time.MonsterFlow,
            trackedProperties: [Keys.Timer  ~>> NSDate().timeIntervalSince(startTime)]
        )
        if ServiceConfiguration.activeConfiguration().logging {
            print("Logger: deinit \(className)")
        }
        do {
            //Preparation to play - Костыль
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.ambient, mode: .moviePlayback)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
        }
        catch {
            // report for an error
        }
    }
}

extension MonsterMasterViewController: EasyTipViewDelegate {
    func easyTipViewDidDismiss(_ tipView: EasyTipView) {
        tipView.dismiss()
    }
}
