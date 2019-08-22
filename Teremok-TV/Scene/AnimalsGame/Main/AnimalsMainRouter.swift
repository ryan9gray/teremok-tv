//
//  AnimalsMainRouter.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 19/05/2019.
//  Copyright (c) 2019 xmedia. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol AnimalsMainRoutingLogic: CommonRoutingLogic {
    func navigateToStatistic()
    func navigateToStart()
}

protocol AnimalsMainDataPassing {
    var dataStore: AnimalsMainDataStore? { get }
}

class AnimalsMainRouter: AnimalsMainRoutingLogic, AnimalsMainDataPassing {
    weak var viewController: AnimalsMainViewController?
    var dataStore: AnimalsMainDataStore?
    var modalControllersQueue = Queue<UIViewController>()

    func navigateToStatistic() {
        let controller = AnimalsStatisticViewController.instantiate(fromStoryboard: .animals)
        guard var dataStore = controller.router?.dataStore else { return }
        dataStore.isEasy = !LocalStore.animalsIsHard
        viewController?.masterRouter?.presentNextChild(viewController: controller)
    }

    func navigateToStart() {
        guard !LocalStore.firstAnimalsIntroduce() else {
            introduce()
            return
        }
        let controller = AnimalsRoundsViewController.instantiate(fromStoryboard: .animals)
        viewController?.masterRouter?.presentNextChild(viewController: controller)
    }

    func introduce() {
        let controller = IntroduceVideoViewController.instantiate(fromStoryboard: .common)
        controller.video = .introduce
        controller.action = { [weak self] in
            self?.navigateToStart()
        }
        viewController?.masterRouter?.presentNextChild(viewController: controller)
    }
}
