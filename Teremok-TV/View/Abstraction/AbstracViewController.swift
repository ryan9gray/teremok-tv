//
//  AbstracViewController.swift
//  Teremok-TV
//
//  Created by R9G on 24/08/2018.
//  Copyright © 2018 xmedia. All rights reserved.
//

import UIKit

protocol MasterModuleDisplayLogic: CommonDisplayLogic {
    func openSettings()
    func openAutorization()
}

class AbstracViewController: UIViewController {
    weak var masterRouter: MasterRoutingLogic?
    
    var showKidsPlusButton: Bool = false

    deinit {
        if ServiceConfiguration.activeConfiguration().logging {
            print("Logger: deinit \(className)")
        }
    }
}

class MusicViewController: UIViewController {
    weak var masterRouter: MusicMasterRoutingLogic?

    var master: MusicMasterDisplayLogic? {
        return masterRouter?.viewController
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        master?.canBack()
    }

    deinit {
        if ServiceConfiguration.activeConfiguration().logging {
            print("Logger: deinit \(className)")
        }
    }
}
class GameViewController: UIViewController {
    weak var masterRouter: GameParentRouting?

    var master: MasterModuleDisplayLogic? {
        return masterRouter?.moduleRouter
    }

    deinit {
        if ServiceConfiguration.activeConfiguration().logging {
            print("Logger: deinit \(className)")
        }
    }
}

protocol IntroduceViewController: class {
    var action: (() -> Void)? { get set }
    func setAction(_ action: (() -> Void)?)

}
extension IntroduceViewController where Self: UIViewController {
    func setAction(_ action: (() -> Void)?) {
        self.action = action
    }
}
