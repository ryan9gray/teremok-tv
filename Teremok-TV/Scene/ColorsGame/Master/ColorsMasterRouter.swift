//
//  ColorsMasterRouter.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 08/09/2019.
//  Copyright (c) 2019 xmedia. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ColorsMasterRoutingLogic: GameParentRouting {
    func openStatistic()
}

protocol ColorsMasterDataPassing {
    var dataStore: ColorsMasterDataStore? { get }
}

class ColorsMasterRouter: ColorsMasterRoutingLogic, ColorsMasterDataPassing {
    weak var viewController: ColorsMasterViewController?
    var dataStore: ColorsMasterDataStore?
    var modalControllersQueue = Queue<UIViewController>()

    // MARK: Routing
    func openStatistic() {
        guard modalChildVC == nil else { return }

        let vc = ColorsGameStatViewController.instantiate(fromStoryboard: .colors)
        viewController?.presentAlertModally(alertController: vc)
    }

    func navigateMain() {
        pushChild(viewControllerClass: ColorsStartViewController.self, storyboard: .colors)
    }
    private let navigationSubscriptions = Subscriptions<Bool>()
    func subscribeForNavigation(_ callback: @escaping  (_ available: Bool) -> Void) -> Subscription {
        navigationSubscriptions.add(callback)
    }
    /**
     Clean hierarchy
     */
    func dismiss() {
        viewController?.dismiss(animated: true)
    }

    func startFlow(_ idx: Int) {
        guard let controller = viewController else { return }

        let flow = ColorsGameFlow(master: controller)
        flow.startFlow()
    }

    var moduleRouter: MasterModuleDisplayLogic? {
        return viewController
    }
    var modalChildVC: GameViewController? {
        didSet {
            navigationSubscriptions.fire(canPop())
        }
    }
    var childControllersStack = Stack<GameViewController>() {
        didSet {
            navigationSubscriptions.fire(canPop())
        }
    }

    func pushChild(_ vc: GameViewController){
        remove()
        childControllersStack.toEmpty()
        add(asChildViewController: vc)
    }

    func presentModalChild(viewController: GameViewController?) {
        if let vc = modalChildVC {
            remove(asChildViewController: vc)
            modalChildVC = nil
        } else {
            remove()
        }
        if let viewController = viewController {
            presentChild(viewController: viewController)
            viewController.masterRouter = self
            modalChildVC = viewController
        }
    }

    func pushChild<T: GameViewController>(viewControllerClass: T.Type, storyboard: StoryboardWorker = .main){
        remove()
        childControllersStack.toEmpty()
        add(asChildViewController: viewControllerClass.instantiate(fromStoryboard: storyboard))
    }

    func add(asChildViewController viewController: GameViewController) {
        viewController.masterRouter = self
        childVC = viewController
        self.viewController?.addChild(viewController)
        presentChild(viewController: viewController)
    }

    func presentChild(viewController: GameViewController){
        UIView.transition(with: viewController.view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.viewController?.view.insertSubview(viewController.view, at: 1)
        }, completion: nil)
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		//viewController.didMove(toParent: viewController)
    }

    func introduceController<T: GameViewController>(viewController: T, completion: @escaping (Bool) -> Void)
        where T: IntroduceViewController {
        viewController.setAction { finish in
            completion(finish)
        }
        viewController.modalPresentationStyle = .fullScreen
        self.viewController?.present(viewController, animated: true, completion: nil)
    }

    func presentNextChild<T: GameViewController>(viewController: T){
        remove()
        add(asChildViewController: viewController)
    }

    func popChild(){
        if  modalChildVC != nil {
            presentModalChild(viewController: nil)
            presentChild(viewController: childVC!)
            return
        }
        guard let oldVC = childControllersStack.pop() else { return }
        remove(asChildViewController: oldVC)
        guard let vc = childControllersStack.top else { return }
        presentChild(viewController: vc)
    }
}
