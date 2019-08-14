//
//  AlphaviteStatisticViewController.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 10/08/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

import UIKit

class AlphaviteStatisticViewController: GameViewController {
    @IBOutlet private var leftStackView: UIStackView!
    @IBOutlet private var rightStackView: UIStackView!
    @IBOutlet private var leftGradientView: GradientView!
    @IBOutlet private var rightGradientView: GradientView!
    @IBOutlet private var goodTitleLabel: UILabel!
    @IBOutlet private var badTitleLabel: UILabel!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var avatarButton: AvatarButton!
    
    var activityView: LottieHUD?

    @IBAction private func closeTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    var input: Input!

    struct Input {
        var good: [String: String]
        var bad: [String: String]
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        displayProfile()
        input.good.keys.sorted().forEach { char in
            let view = AlphaviteStatView.fromNib()
            view.set(char: char, count: input.good[char]!)
            NSLayoutConstraint.fixHeight(view: view, constant: 30.0)
            leftStackView.addArrangedSubview(view)
        }
        input.bad.keys.sorted().forEach { char in
            let view = AlphaviteStatView.fromNib()
            view.set(char: char, count: input.bad[char]!)
            NSLayoutConstraint.fixHeight(view: view, constant: 30.0)
            rightStackView.addArrangedSubview(view)
        }
        goodTitleLabel.textColor = UIColor.Alphavite.Button.greenTwo
        badTitleLabel.textColor = UIColor.Alphavite.Button.redTwo


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
