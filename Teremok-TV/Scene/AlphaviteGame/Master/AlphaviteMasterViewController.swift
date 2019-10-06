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

class AlphaviteMasterViewController: UIViewController, AlphaviteMasterDisplayLogic {
    var interactor: AlphaviteMasterBusinessLogic?
    var router: (CommonRoutingLogic & AlphaviteMasterRoutingLogic & AlphaviteMasterDataPassing)?
    var modallyControllerRoutingLogic: CommonRoutingLogic? {
        get { return router }
    }
    var activityView: LottieHUD?
    var tipView: EasyTipView?

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
    @IBOutlet var backgroundView: UIImageView!
    @IBOutlet private var homeBtn: KeyButton!
    @IBOutlet private var avatarButton: AvatarButton!
    private let startTime = Date()

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
    let bundleResourceRequest = NSBundleResourceRequest(tags: Set([OnDemandLoader.Tags.Prefetch.alphabetImages.rawValue, OnDemandLoader.Tags.Prefetch.alphabetSounds.rawValue]))

    override func viewDidLoad() {
        super.viewDidLoad()
        bundleResourceRequest.loadingPriority = NSBundleResourceRequestLoadingPriorityUrgent
        bundleResourceRequest.conditionallyBeginAccessingResources { [unowned self] available in
                if available {
                    DispatchQueue.main.async {
                      self.router?.navigateMain()
                    }
                  } else {
                    self.bundleResourceRequest.beginAccessingResources { error in
                        DispatchQueue.main.async {
                        if error != nil {
                            self.present(errorString: "Игра загружается, попробуйте позже") {
                                self.dismiss(animated: true)
                            }
                        } else {
                            self.router?.navigateMain()
                        }
                        }
                      }
                  }

        }
        do {
            //Preparation to play
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: .moviePlayback)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
        }
        catch {
            // report for an error
        }

        displayProfile()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if !avatarButton.isHidden, LocalStore.alphabetTip < 3 {
            LocalStore.alphabetTip += 1
            var preferences = EasyTipView.Preferences()
            preferences.drawing.font = Style.Font.istokWeb(size: 16)
            preferences.drawing.foregroundColor = UIColor.View.titleText
            preferences.drawing.backgroundColor = .white
            preferences.drawing.arrowPosition = EasyTipView.ArrowPosition.right
            tipView = EasyTipView(text: "Здесь можно посмотреть статистику", preferences: preferences, delegate: self)
            tipView?.show(animated: true, forView: avatarButton, withinSuperview: view)
        }
    }

    // MARK: Do something

    func displayProfile() {
        guard let childs = Profile.current?.childs else {
            avatarButton.isHidden = true
            return
        }

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
        dismiss(animated: true) {
            self.output.openSettings()
        }
    }

    func openAutorization() {
        dismiss(animated: true) {
            self.output.openAuthorization()
        }
    }

    deinit {
        track(
            Events.Time.AlphabetFlow,
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

extension AlphaviteMasterViewController: EasyTipViewDelegate {
    func easyTipViewDidDismiss(_ tipView: EasyTipView) {
        tipView.dismiss()
    }
}
