//
//  DinoStatisticViewController.swift
//  Teremok-TV
//
//  Created by Виктор Пузаков on 06.04.2020.
//  Copyright © 2020 xmedia. All rights reserved.
//

import UIKit

protocol DinoStatisticDisplayLogic: CommonDisplayLogic {
    func showStats(_ model: DinoStatisticViewController.Input)
}

class DinoStatisticViewController: UIViewController, DinoStatisticDisplayLogic {
    @IBOutlet private var userName: UILabel!
    @IBOutlet private var lastWeekTime: UILabel!
    @IBOutlet private var lastWeekLbl: UILabel!
    @IBOutlet private var thisWeekTime: UILabel!
    @IBOutlet private var thisWeekLbl: UILabel!
    @IBOutlet private var statStatus: UILabel!
    @IBOutlet private var homeBtn: KeyButton!
    @IBOutlet private var avatarBtn: AvatarButton!
    @IBOutlet private var avgTimeLbl: UILabel!
    
    @IBAction private func closeTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    var interactor: DinoStatisticBusinessLogic?
    var router: (CommonRoutingLogic & DinoStatisticRoutingLogic & DinoStatisticDataPassing)?
    var modallyControllerRoutingLogic: CommonRoutingLogic? {
        get { return router }
    }
    var activityView: LottieHUD?

    struct Input {
        var stat: MonsterStatisticResponse
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        let viewController = self
        let interactor = DinoStatisticInteractor()
        let presenter = DinoStatisticPresenter()
        let router = DinoStatisticRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userName.textColor = UIColor.Label.yellow
        thisWeekLbl.textColor = .white
        thisWeekTime.textColor = UIColor.Label.yellow
        lastWeekLbl.textColor = .white
        lastWeekTime.textColor = UIColor.Label.yellow
        avgTimeLbl.textColor = .white
        statStatus.textColor = .white
        
        activityView = LottieHUD()
        displayProfile()
        showPreloader()
        interactor?.fetchStat()
    }
    
    func fillInfo(model: Input) {
        thisWeekTime.text = model.stat.currentweek.time == 0 ? "-" : PlayerHelper.stringFromTimeInterval(TimeInterval(model.stat.currentweek.time))
        lastWeekTime.text = model.stat.pastweek.time == 0 ? "-" : PlayerHelper.stringFromTimeInterval(TimeInterval(model.stat.pastweek.time))
        if model.stat.currentweek.time > model.stat.pastweek.time {
            statStatus.text = "Ты стал медленно находить монстров, нужно ускориться!"
        }
        else {
            statStatus.text = "Теперь ты стал находить монстров быстрее!"
        }
        if model.stat.currentweek.time == 0 || model.stat.pastweek.time == 0 {
            statStatus.text = "Обновление вашей статистики будет " + updateDaysText(days: model.stat.daysToUpdate)
        }
    }

    func updateDaysText(days: Int) -> String {
        let daysText: String
        switch days {
        case 0:
            return "сегодня"
        case 1:
            daysText = "день"
        case 2,3,4:
            daysText = "дня"
        default:
            daysText = "дней"
        }
        return "через \(days) " + daysText
    }
    
    func showStats(_ model: Input) {
        fillInfo(model: model)
        hidePreloader()
    }
    
    func displayProfile() {
        guard let child = Profile.currentChild else { return }
        
        if let avatar = child.pic {
            avatarBtn.setAvatar(linktoLoad: avatar)
            
        }
        if let name = child.name {
            userName.text = name
        }
    }
}
