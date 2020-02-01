//
//  SettingsViewController.swift
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

protocol SettingsDisplayLogic: CommonDisplayLogic {
    func displayProfile(_ profile: Profile)
	func setPromoCode(code: String)
}

final class SettingsViewController: AbstracViewController, SettingsDisplayLogic {
    var activityView: LottieHUD?
    
    var modallyControllerRoutingLogic: CommonRoutingLogic? {
        get { return router }
    }
    var interactor: SettingsBusinessLogic?
    var router: (NSObjectProtocol & SettingsRoutingLogic & SettingsDataPassing & CommonRoutingLogic)?

    @IBOutlet private var childsView: UIView!
    @IBOutlet private var authView: UIView!
    @IBOutlet private var redProfileBtn: UIButton!
    @IBOutlet private var profileTitle: UILabel!
    @IBOutlet private var subscribeTitle: UILabel!
    @IBOutlet private var promoCode: OrangeButton!
    @IBOutlet private var subscrideSubtitle: UILabel!
    @IBOutlet private var logInBtn: UIRoundedButtonWithGradientAndShadow!
    @IBOutlet private var registrationBtn: UIRoundedButtonWithGradientAndShadow!
    @IBOutlet private var childStack: ChildsStackView!
    @IBOutlet private var logoutBtn: OrangeButton!

    @IBAction func logInClick(_ sender: Any) {
        router?.routToAuthorization()
    }
    @IBAction func regClick(_ sender: Any) {
        router?.routToRegistration()
    }
    
    @IBAction func buyClick(_ sender: Any) {
      router?.navigareToStore()
    }

    @IBAction func logoutClick(_ sender: Any) {
        interactor?.logout()
        masterRouter?.logout()
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
        let interactor = SettingsInteractor()
        let presenter = SettingsPresenter()
        let router = SettingsRouter()
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
        
        prepareUI()
    }

    private func prepareUI(){
        activityView = LottieHUD()
        registrationBtn.gradientColors = Style.Gradients.beige.value
        logInBtn.gradientColors = Style.Gradients.beige.value
        childStack.delegate = self
        let isAuth = Profile.isAuthorized
        setMode(isAuth: isAuth)
        if isAuth {
            interactor?.fetchData()
        }
    }
    // MARK: Do something

    func displayProfile(_ profile: Profile) {
        let emeil = profile.email ?? ""
        profileTitle.text = "Электронная почта аккаунта " + emeil

        let subscribeTitleText: String
        if profile.premiumGame {
            subscribeTitleText = "У Вас подписка «Интеллектум»"
        } else if profile.premiumMusic {
            subscribeTitleText = "У Вас подписка «Дети Супер +»"
        } else if profile.premium {
            subscribeTitleText = "У Вас подписка «Дети+»"
        } else {
            subscribeTitleText = "Возможности подписки»"
        }
        subscribeTitle.text = subscribeTitleText

        let isAuth = Profile.isAuthorized
        setMode(isAuth: isAuth)
        childStack.setAvatars(childs: profile.childs)
    }

    func setMode(isAuth: Bool) {
        authView.isHidden = isAuth
        childsView.isHidden = !isAuth
        logoutBtn.isHidden = !isAuth
        profileTitle.isHidden = !isAuth
    }

	// MARK: PromoCode

	var promoState: Settings.Promo = .inputCode
	var needShowPromoCode = false

	@IBAction func promoClick(_ sender: Any) {
		switch promoState {
			case .inputCode:
				let vc = InputAlertViewController.instantiate(fromStoryboard: .alerts)
				vc.model = AlertModel(title: "Введите промокод", subtitle: "АКТИВИРОВАТЬ")
				vc.modalTransitionStyle = .crossDissolve
				vc.modalPresentationStyle = .overCurrentContext
				vc.complition = code
				presentAlertModally(alertController: vc)
			case .shareCode(let code):
				showPromocode(code)
		}
	}

	func showPromocode(_ code: String) {
		let vc = CloudAlertViewController.instantiate(fromStoryboard: .alerts)
		vc.model = AlertModel(title: "Поздравляем!", subtitle: "Вы получили от «Теремок-ТВ» промо-код для друга на бесплатное использование подписки «Дети +». Порадуйте своих друзей, отправьте, пожалуйста, этот код одному из ваших друзей, у кого есть маленькие дети. Код \(code)", buttonTitle: "Поделиться")
		vc.modalTransitionStyle = .crossDissolve
		vc.modalPresentationStyle = .overCurrentContext
		vc.complition = { [weak self] in
			self?.shareCode(code)
		}
		presentAlertModally(alertController: vc)
	}

	func shareCode(_ code: String) {
		let sharedString = "Дорогой друг, дарю тебе и твоему малышу промо-код на 30 дней бесплатного использования приложения с обучающими мультфильмами - «Теремок-ТВ». Промо-код - " + code
			+ "\nСкачать приложение - https://itunes.apple.com/ru/app//id1421920317?l=en&mt=8"
		let vc = UIActivityViewController(activityItems: [sharedString], applicationActivities: [])
		vc.excludedActivityTypes = [UIActivity.ActivityType.mail, UIActivity.ActivityType.postToFacebook]
		if let wPPC = vc.popoverPresentationController {
			wPPC.barButtonItem = self.navigationItem.rightBarButtonItem
		}
		present(vc, animated: true)
	}

	func code(_ code: String) {
		guard !code.isEmpty else { return }
		interactor?.acivateCode(code)
	}
	func setPromoCode(code: String) {
		DispatchQueue.main.async {
			self.promoCode.setTitle("Поделиться промокодом", for: .normal)
			self.promoState = .shareCode(code)
			if self.needShowPromoCode {
				self.showPromocode(code)
			}
		}
	}
}

extension SettingsViewController: ChildsStackProtocol {
    
    func plusKids() {
        let vc = ChildProfileAddViewController.instantiate(fromStoryboard: .autorization)
        guard var dataStore = vc.router?.dataStore else { return }
        dataStore.screen = .Add
        masterRouter?.pushChild(vc)
    }
    
    func childClick(_ child: Child) {
        router?.routToChild(child)
    }
}
