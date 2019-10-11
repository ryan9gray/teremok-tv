//
//  AnimalsMasterViewController.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 18/05/2019.
//  Copyright (c) 2019 xmedia. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import AVKit
import Trackable

protocol AnimalsMasterDisplayLogic: MasterModuleDisplayLogic, TrackableClass {
    func setDifficult(isEasy: Bool)
}

class AnimalsMasterViewController: UIViewController, AnimalsMasterDisplayLogic {
    var interactor: AnimalsMasterBusinessLogic?
    var router: (AnimalsMasterRoutingLogic & AnimalsMasterDataPassing & CommonRoutingLogic)?
    var activityView: LottieHUD?
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
        let interactor = AnimalsMasterInteractor()
        let presenter = AnimalsMasterPresenter()
        let router = AnimalsMasterRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }

    // MARK: View lifecycle
    @IBOutlet var backgroundView: UIImageView!
    @IBOutlet private var backNavBtn: TTAbstractMainButton!
    private let startTime = Date()

    @IBAction func backClick(_ sender: UIButton) {
        if (router?.canPop())! {
            router?.popChild()
        } else {
            dismiss(animated: true, completion: nil)
        }
    }

    func setDifficult(isEasy: Bool) {
        interactor?.changeComplexity(isEasy: isEasy)
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

        do {
            //Preparation to play
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: .moviePlayback)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
        }
        catch {
            // report for an error
        }

        setupTrackableChain(parent: analytics)
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

    var output: Output!

    struct Output {
        var openSettings: () -> Void
        var openAuthorization: () -> Void
    }

    deinit {
        track(
            Events.Time.AnimalFlow,
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
