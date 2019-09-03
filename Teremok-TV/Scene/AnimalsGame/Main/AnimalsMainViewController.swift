//
//  AnimalsMainViewController.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 19/05/2019.
//  Copyright (c) 2019 xmedia. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol AnimalsMainDisplayLogic: CommonDisplayLogic {
    
}

class AnimalsMainViewController: GameViewController, AnimalsMainDisplayLogic {
    var interactor: AnimalsMainBusinessLogic?
    var router: (AnimalsMainRoutingLogic & AnimalsMainDataPassing & CommonRoutingLogic)?
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
        let interactor = AnimalsMainInteractor()
        let presenter = AnimalsMainPresenter()
        let router = AnimalsMainRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }

    // MARK: View lifecycle
    @IBOutlet private var avatarButton: AvatarButton!

    @IBAction func infoClick(_ sender: Any) {
        showInfo()
    }
    
    @IBAction func avatarClick(_ sender: Any) {
        router?.navigateToStatistic()
    }

    @IBAction func startClick(_ sender: Any) {
        router?.navigateToStart()
    }

    var tipNeedShow = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        displayProfile()
        if LocalStore.animalsTip < 3 {
            LocalStore.animalsTip += 1
            var preferences = EasyTipView.Preferences()
            preferences.drawing.font = Style.Font.istokWeb(size: 16)
            preferences.drawing.foregroundColor = UIColor.View.titleText
            preferences.drawing.backgroundColor = .white
            preferences.drawing.arrowPosition = EasyTipView.ArrowPosition.right
            tipView = EasyTipView(text: "Здесь можно посмотреть статистику", preferences: preferences, delegate: self)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if tipNeedShow {
            tipNeedShow = false
            tipView?.show(animated: true, forView: avatarButton, withinSuperview: view)
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        tipView?.dismiss()
    }

    func showInfo() {
        let text = "Развивающая игра «Жила-была Царевна: Животные» даст возможность вашему малышу учить по 50 новых животных ежемесячно (ежемесячное обновление библиотеки животных). Интерфейс игры спроектирован таким образом, чтобы вместе с наименования животных ваш ребёнок мог учить и буквы. Еженедельная статистика в игре вам позволит оценивать прогресс в обучении вашего ребёнка. Надеемся, что игра понравится вашему малышу и вы сможете легко и весело давать ему новые знания вместе с нами!"

        presentCloud(title: "Здравствуйте!", subtitle: text, completion: nil)
    }

    func displayProfile(){
        guard let childs = Profile.current?.childs else {
            avatarButton.isHidden = true
            return
        }

        if let avatar = childs.first(where: {$0.current ?? false})?.pic {
            avatarButton.setAvatar(linktoLoad: avatar)
        }
    }
}
extension AnimalsMainViewController: EasyTipViewDelegate {
    func easyTipViewDidDismiss(_ tipView: EasyTipView) {
        tipView.dismiss()
    }
}
