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
    @IBOutlet private var backgroundImageView: UIImageView!
    @IBOutlet private var userName: UILabel!
    @IBOutlet private var lastWeekTime: UILabel!
    @IBOutlet private var lastWeekLbl: UILabel!
    @IBOutlet private var thisWeekTime: UILabel!
    @IBOutlet private var thisWeekLbl: UILabel!
    @IBOutlet private var statStatus: UILabel!
    @IBOutlet private var homeBtn: KeyButton!
    @IBOutlet private var avatarBtn: AvatarButton!
    @IBOutlet private var avgTimeLbl: UILabel!
    @IBOutlet private var topSeparatorView: UIView!
    @IBOutlet private var bottomSeparatorView: UIView!
    
    @IBOutlet private var statStatusView: UIView!
    @IBOutlet private var nilStatisticLabel: UILabel!
    @IBOutlet private var titleClearStatisticLabel: UILabel!
    @IBOutlet private var nilStatisticView: UIView!
    
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
        
        homeBtn.gradientColors = Style.Gradients.DinoGame.green.value
        
        userName.textColor = .white
        thisWeekLbl.textColor = .white
        thisWeekTime.textColor = UIColor.Label.darkRed
        lastWeekLbl.textColor = .white
        lastWeekTime.textColor = UIColor.Label.darkRed
        avgTimeLbl.textColor = UIColor.Label.peach
        
        activityView = LottieHUD()
        displayProfile()
        showPreloader()
        interactor?.fetchStat()
    }
    
    func fillInfo(model: Input) {
        thisWeekTime.text = model.stat.currentweek.time == 0 ? "-" : PlayerHelper.stringFromTimeInterval(TimeInterval(model.stat.currentweek.time))
        lastWeekTime.text = model.stat.pastweek.time == 0 ? "-" : PlayerHelper.stringFromTimeInterval(TimeInterval(model.stat.pastweek.time))
        if model.stat.currentweek.time > model.stat.pastweek.time {
            statStatus.text = "Ты стал медленно находить динозавров, нужно ускориться!"
            statStatus.textColor = UIColor.Label.darkRed
        }
        else {
            statStatus.text = "Теперь ты стал находить динозавров быстрее!"
            statStatus.textColor = UIColor.DinoGame.darkGreenTwo
        }
        if model.stat.currentweek.time == 0 || model.stat.pastweek.time == 0 {
            avgTimeLbl.isHidden = true
            lastWeekTime.isHidden = true
            lastWeekLbl.isHidden = true
            thisWeekTime.isHidden = true
            thisWeekLbl.isHidden = true
            statStatus.isHidden = true
            topSeparatorView.isHidden = true
            bottomSeparatorView.isHidden = true
            statStatusView.isHidden = true
            
            nilStatisticView.isHidden = false
            backgroundImageView.image = UIImage(named: "ic-dinoGameStatistic1")
            nilStatisticLabelConfigure(beginString: "Статистика ведётся по результатам",
                                       endString: " 7-ми дней",
                                       label: titleClearStatisticLabel)
            nilStatisticLabelConfigure(beginString: "Обновление вашей статистики будет ",
                                       endString: updateDaysText(days: model.stat.daysToUpdate),
                                       label: nilStatisticLabel)
            
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
    
    private func nilStatisticLabelConfigure(beginString: String, endString: String, label: UILabel) {
        let string = NSMutableAttributedString()
        let firstAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: UIColor.white.cgColor]
        let secondAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: UIColor.Label.darkRed.cgColor]
        let firstString = NSAttributedString(string: beginString, attributes: firstAttributes)
        let secondString = NSAttributedString(string: endString, attributes: secondAttributes)
        string.append(firstString)
        string.append(secondString)
        label.attributedText = string
    }
}
