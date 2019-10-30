//
//  ColorsGameStatViewController.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 12.10.2019.
//  Copyright (c) 2019 xmedia. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ColorsGameStatDisplayLogic: CommonDisplayLogic {
    func showStats(_ model: ColorsGameStatViewController.Input)

}

class ColorsGameStatViewController: GameViewController, ColorsGameStatDisplayLogic {
    var interactor: ColorsGameStatBusinessLogic?
    var router: (CommonRoutingLogic & ColorsGameStatRoutingLogic & ColorsGameStatDataPassing)?
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
        let interactor = ColorsGameStatInteractor()
        let presenter = ColorsGameStatPresenter()
        let router = ColorsGameStatRouter()
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
        var good: [ColorsMaster.Colors?: String]
        var bad: [ColorsMaster.Colors?: String]
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        activityView = LottieHUD()
        displayProfile()
        goodTitleLabel.textColor = UIColor.Alphavite.greenTwo
        badTitleLabel.textColor = UIColor.Alphavite.redTwo
        leftGradientView.gradientColors = Style.Gradients.green.value
        rightGradientView.gradientColors = Style.Gradients.red.value

        showPreloader()
        interactor?.fetchStat()
    }

    func showStats(_ model: Input) {
        rightStackView.subviews.forEach { $0.removeFromSuperview() }
        leftStackView.subviews.forEach { $0.removeFromSuperview() }
        model.good.forEach { key, value in
            guard let key = key else { return }
            let view = ColorsGameStatView.fromNib()
            view.set(color: key, count: value)
            NSLayoutConstraint.fixHeight(view: view, constant: 30.0)
            leftStackView.addArrangedSubview(view)
        }
        model.bad.forEach { key, value in
            guard let key = key else { return }
            let view = ColorsGameStatView.fromNib()
            view.set(color: key, count: value)
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
            titleLabel.textColor = UIColor.ColorsGame.purp
        }
    }

}
