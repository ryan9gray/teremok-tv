//
//  GameStartViewController.swift
//  Teremok-TV
//
//  Created by Eugene Ivanov on 29.10.2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

import UIKit

class GameStartViewController: GameViewController {
    var tipView: EasyTipView?
    @IBOutlet var avatarButton: AvatarButton!
    var tipNeedShow = true

    override func viewDidLoad() {
        super.viewDidLoad()


        displayProfile()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

//        if tipNeedShow {
//            tipNeedShow = false
//            tipView?.show(animated: true, forView: avatarButton, withinSuperview: view)
//        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        tipView?.dismiss()
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
extension GameStartViewController: EasyTipViewDelegate {
    func easyTipViewDidDismiss(_ tipView: EasyTipView) {
        tipView.dismiss()
    }
}
