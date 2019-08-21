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

class MonsterMasterViewController: UIViewController, MonsterMasterDisplayLogic {
    var interactor: MonsterMasterBusinessLogic?
    var router: (CommonRoutingLogic & MonsterMasterRoutingLogic & MonsterMasterDataPassing)?
    var modallyControllerRoutingLogic: CommonRoutingLogic? {
        get { return router }
    }
    var activityView: LottieHUD?
    var tipView: EasyTipView?
    
    func displayProfile() {
        guard let childs = Profile.current?.childs else { return }
        
        if let avatar = childs.first(where: {$0.current ?? false})?.pic {
            avatarButton.setAvatar(linktoLoad: avatar)
        }
    }
    
    var output: Output!
    
    struct Output {
        var openSettings: () -> Void
        var openAuthorization: () -> Void
    }
    
    func openSettings() {
        output.openSettings()
    }
    
    func openAutorization() {
        output.openAuthorization()
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
    @IBOutlet var backgroundView: UIImageView!
    @IBOutlet private var homeBtn: KeyButton!
    @IBOutlet private var avatarButton: AvatarButton!
    private let startTime = Date()
    
    @IBAction func avatarClick(_ sender: Any) {
        tipView?.dismiss()
        router?.openStatistic()
    }
    
    @IBAction private func homeClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        displayProfile()
        router?.navigateMain()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if LocalStore.monsterTip < 3 {
            LocalStore.monsterTip += 1
            var preferences = EasyTipView.Preferences()
            preferences.drawing.font = Styles.Font.montsserat(size: 16)
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