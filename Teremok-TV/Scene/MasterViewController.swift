//
//  MasterViewController.swift
//  Teremok-TV
//
//  Created by R9G on 22.08.2018.
//  Copyright © 2018 xmedia. All rights reserved.
//

import UIKit
import UserNotifications
import AVFoundation

protocol MasterDisplayLogic: CommonDisplayLogic {
    func displayProfile()
    func displayAuth()
    func showMain()
    func prepareBackground()
    var isKidsPlusShow: Bool { get }
}

final class MasterViewController: UIViewController, MasterDisplayLogic, CAAnimationDelegate {
    var activityView: LottieHUD?
    var interactor: MasterBusinessLogic?
    var router: (NSObjectProtocol & MasterVCRoutingLogic & MasterDataPassing & CommonRoutingLogic)?

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    var modallyControllerRoutingLogic: CommonRoutingLogic? {
        get { return router }
    }
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let interactor = MasterInteractor()
        let presenter = MasterPresenter()
        let router = MasterRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }

    @IBOutlet private var downloadProgress: UIProgressView!
    @IBOutlet var backgroundView: UIImageView!
    @IBOutlet private var allButtons: [TTAbstractMainButton]!
    @IBOutlet private var kidsPlusBtn: UIButton!
    @IBOutlet private var childStack: ChildsStackView!
    @IBOutlet private var achievmentBtn: BadgeButton!
    @IBOutlet private var heartBtn: BadgeButton!
    @IBOutlet private var homeBtn: TTAbstractMainButton!
    @IBOutlet private var musicBtn: TTAbstractMainButton!
    @IBOutlet private var animalsBtn: TTAbstractMainButton!

    @IBAction func kidsPlusClick(_ sender: UIButton) {
        selectButton(sender)
        router?.navigateToStore()
    }
    @IBAction func logoClick(_ sender: UIButton) {
        selectButton(homeBtn)
        router?.navigateToMain()
    }
    @IBAction func settingsClick(_ sender: UIButton) {
        selectButton(sender)
        router?.navigateToSettings()
    }
    @IBAction func searchClick(_ sender: UIButton) {
        selectButton(sender)
        router?.navigateToSearch()
    }
    @IBAction func achieveClick(_ sender: UIButton) {
        selectButton(sender)
        router?.navigateToAchieves()
    }
    @IBAction func heartClick(_ sender: UIButton) {
        selectButton(sender)
        router?.navigateToFav()
    }
    @IBAction func musicClick(_ sender: UIButton) {
        router?.navigateToMusic()
    }
    @IBAction func gameClick(_ sender: UIButton) {
        router?.navigateToGameList()
        //router?.navigateToAnimals()
    }
    @IBAction func touchDown(_ sender: UIButton) {
		if !Profile.isAuthorized {
            sender.cancelTracking(with: nil)
            presentCloud(title: "", subtitle: Main.Messages.auth, button: "Зарегистрироваться") { [weak self] in
                self?.router?.navigateToReg()
            }
        }
        if isOffline {
            sender.cancelTracking(with: nil)
            presentCloud(
                title: "Offline",
                subtitle: "Отсутствует подключение к Интернету или слишком слабый сигнал. Вам доступны только сохраненные на телефон мультфильмы."
            ) { [weak self] in
                self?.router?.navigateToFav()
            }
        }
    }

    var isOffline = false
    var audioPlayer: AVAudioPlayer?

    private func selectButton(_ button: UIButton){
        deselectButtons()
        button.isSelected = true
    }

    private func deselectButtons(){
        audioPlayer?.play()
        self.allButtons.forEach { $0.isSelected = false }
    }

    var isPremium: Bool = false
    var isKidsPlusShow: Bool = true {
        didSet{
            DispatchQueue.main.async {
                self.kidsPlusBtn.isHidden = self.isPremium ? true : !self.isKidsPlusShow
            }
        }
    }

    @objc private func uploadDidProgress(_ notification: Notification) {
        if let progress = notification.object as? Double {
            DispatchQueue.main.async {
                self.downloadProgress.progress = Float(progress)
                if progress == 1 {
                    self.downloadProgress.progress = 0
                }
            }            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(updateProfile), name: .ProfileDidChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.uploadDidProgress(_:)), name: .UploadProgress, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.addBadge), name: .AchievmentBadge, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.addBadge), name: .FavBadge, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.offline), name: .Internet, object: nil)

        let buttonSound = URL(fileURLWithPath: Bundle.main.path(forResource: "push_button_sound", ofType: "wav")!)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: buttonSound)
        } catch {
            print("no file \(buttonSound)")
        }
        prepareUI()
        interactor?.identifySession()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    @objc func offline(_ notification: Notification) {
        if let offline = notification.object as? Bool {
            self.isOffline = offline
            if offline{
                presentCloud(title: "Offline", subtitle: "Отсутствует подключение к Интернету или слишком слабый сигнал. Вам доступны только сохраненные на телефон мультфильмы.", completion: nil)
            }
        }

    }

    @objc func addBadge(_ notification: Notification) {
        DispatchQueue.main.async {
			if let info = notification.userInfo {
				var bagButton: BadgeButton?
				var count = 0
				if let fav = info["Fav"] as? Int {
					bagButton = self.heartBtn
					count = fav
				}
				if let ach = info["Ach"] as? Int {
					bagButton = self.achievmentBtn
					count = ach
				}
				guard let btn = bagButton  else { return }

				btn.tintColor = UIColor.darkGray
				btn.badgeEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 15)
				btn.addbadgetobutton(badge: count)
				self.view.layoutIfNeeded()
			}
        }
    }
    
    private func prepareUI(){
        childStack.delegate = self
        prepareBackground()
        displayProfile()
    }

    func prepareBackground(){
        BackgroundMediaWorker.setImage(background: backgroundView)
    }

    func showMain(){
        router?.navigateToMain()
    }
    
    func displayAuth(){
        deselectButtons()
        router?.navigateToReg()
        isKidsPlusShow = false
        kidsPlusBtn.isHidden = true
    }

    func logout(){
        interactor?.logoutSession()
    }

    func displayProfile() {
        let profile = Profile.current
        isPremium = profile?.premium ?? false
        isKidsPlusShow = !isPremium

        guard var childs = profile?.childs else {
            childStack.setAvatars(childs:[])
            return
        }
        if let currentChilds = childs.firstIndex(where: {$0.current ?? false}) {
            childs.swapAt(currentChilds, 0)
        }
        childStack.setAvatars(childs: childs)
    }
    
    @objc func updateProfile(){
        DispatchQueue.main.async {
            self.displayProfile()
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension MasterViewController: ChildsStackProtocol {
    func plusKids() {
        deselectButtons()
        router?.navigateToAddChild()
    }
    
    func childClick(_ child: Child) {
        deselectButtons()
        router?.pushChild(viewControllerClass: ChildsViewController.self, storyboard: .profile)
    }
}

extension MasterViewController: PushRoutable {
    func handle(push: TTPush) -> Bool {
        switch push.action {
        case .achieve:
            selectButton(achievmentBtn)
            router?.navigateToAchieves()
            return true
        case .newVideo(let id):
            router?.navigateToVideo(id: id)
            return true
        default:
            return false
        }
    }
}
