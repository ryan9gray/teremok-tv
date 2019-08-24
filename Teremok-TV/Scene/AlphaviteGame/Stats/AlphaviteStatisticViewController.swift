//
//  AlphaviteStatisticViewController.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 17/08/2019.
//  Copyright (c) 2019 xmedia. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol AlphaviteStatisticDisplayLogic: CommonDisplayLogic {
    func showStats(_ model: AlphaviteStatisticViewController.Input)
}

class AlphaviteStatisticViewController: GameViewController, AlphaviteStatisticDisplayLogic {
    var interactor: AlphaviteStatisticBusinessLogic?
    var router: (CommonRoutingLogic & AlphaviteStatisticRoutingLogic & AlphaviteStatisticDataPassing)?
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
        let interactor = AlphaviteStatisticInteractor()
        let presenter = AlphaviteStatisticPresenter()
        let router = AlphaviteStatisticRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }

    // MARK: View lifecycle
    @IBOutlet private var leftStackView: UIStackView!
    @IBOutlet private var rightStackView: UIStackView!
    @IBOutlet private var leftGradientView: GradientView!
    @IBOutlet private var rightGradientView: GradientView!
    @IBOutlet private var goodTitleLabel: UILabel!
    @IBOutlet private var badTitleLabel: UILabel!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var avatarButton: AvatarButton!

    @IBAction private func closeTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }

    struct Input {
        var good: [String: String]
        var bad: [String: String]
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        activityView = LottieHUD()
        showPreloader()
        displayProfile()
        goodTitleLabel.textColor = UIColor.Alphavite.Button.greenTwo
        badTitleLabel.textColor = UIColor.Alphavite.Button.redTwo
        interactor?.fetchStat()
        leftGradientView.gradientColors = Styles.Gradients.green.value
        rightGradientView.gradientColors = Styles.Gradients.red.value
    }

    func showStats(_ model: Input) {
        model.good.keys.sorted().forEach { char in
            let view = AlphaviteStatView.fromNib()
            view.set(char: char, count: model.good[char]!)
            NSLayoutConstraint.fixHeight(view: view, constant: 30.0)
            leftStackView.addArrangedSubview(view)
        }
        model.bad.keys.sorted().forEach { char in
            let view = AlphaviteStatView.fromNib()
            view.set(char: char, count: model.bad[char]!)
            NSLayoutConstraint.fixHeight(view: view, constant: 30.0)
            rightStackView.addArrangedSubview(view)
        }
        hidePreloader()
    }

    func displayProfile() {
        guard let child = Profile.currentChild else { return }

        if let avatar = child.pic {
            avatarButton.setAvatar(linktoLoad: avatar)

        }
        if let name = child.name {
            titleLabel.text = name
            titleLabel.textColor = UIColor.init(hex: "D08946")
        }
    }
}
