//
//  GameMasterViewController.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 08/09/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

import UIKit

class GameMasterViewController: UIViewController {
    @IBOutlet var backgroundView: UIImageView!
    @IBOutlet var homeBtn: KeyButton!
    @IBOutlet var avatarButton: AvatarButton!
    let startTime = Date()

    var output: Output!

    struct Output {
        var openSettings: () -> Void
        var openAuthorization: () -> Void
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        displayProfile()
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

    func displayProfile() {
        guard let childs = Profile.current?.childs else {
            avatarButton.isHidden = true
            return
        }

        if let avatar = childs.first(where: {$0.current ?? false})?.pic {
            avatarButton.setAvatar(linktoLoad: avatar)
        }
    }

}
