//
//  GameParentRouting.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 10/08/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

import UIKit

protocol GameParentRouting: CommonRoutingLogic {
    func presentModalChild(viewController: GameViewController?)
    func canPop() -> Bool
    var childControllersStack: Stack<GameViewController> { get set }
    var childVC: GameViewController?  { get set }
    func pushChild(_ vc: GameViewController)
    func pushChild<T: GameViewController>(viewControllerClass: T.Type, storyboard: StoryboardWorker)
    func presentNextChild<T: GameViewController>(viewController: T)
    func popChild()
    var moduleRouter: MasterModuleDisplayLogic? { get }
    func introduceController<T: GameViewController>(viewController: T, completion: @escaping (Bool) -> Void)
        where T: IntroduceViewController
    var modalChildVC: GameViewController? { get }
    func openStatistic()
    func navigateMain()

    func dismiss()
    func subscribeForNavigation(_ callback: @escaping  (_ available: Bool) -> Void) -> Subscription

    // for anmimals костыль
    func startFlow(_ idx: Int)
}
extension GameParentRouting {

    var childVC: GameViewController? {
        set {
            guard let value = newValue else { return }
            childControllersStack.push(value)
        }
        get {
            return childControllersStack.top
        }
    }

    func canPop() -> Bool {
        return childControllersStack.count > 1 || modalChildVC != nil
    }

    func remove() {
        guard let childVC = self.childVC else { return }
        remove(asChildViewController: childVC)
    }

    func remove(asChildViewController viewController: GameViewController) {
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }
}
