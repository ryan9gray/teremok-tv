//
//  AnimalsMasterRouter.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 18/05/2019.
//  Copyright (c) 2019 xmedia. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit


protocol AnimalsMasterRoutingLogic: GameParentRouting {
    func subscribeForNavigation(_ callback: @escaping  (_ available: Bool) -> Void) -> Subscription

}

protocol AnimalsMasterDataPassing {
    var dataStore: AnimalsMasterDataStore? { get }
}

class AnimalsMasterRouter: AnimalsMasterRoutingLogic, AnimalsMasterDataPassing {
    weak var viewController: AnimalsMasterViewController?

    var dataStore: AnimalsMasterDataStore?
    var modalControllersQueue = Queue<UIViewController>()

    private let navigationSubscriptions = Subscriptions<Bool>()

    func subscribeForNavigation(_ callback: @escaping  (_ available: Bool) -> Void) -> Subscription {
        navigationSubscriptions.add(callback)
    }

    var isEasy: Bool {
        return dataStore?.isEasy ?? true
    }
    // Parent
    func introduceController<T: GameViewController>(viewController: T, completion: @escaping (Bool) -> Void)
    where T: IntroduceViewController {
        modalChildVC?.view.isHidden = true
        viewController.setAction { [weak self] finish in
            completion(finish)
            self?.modalChildVC?.view.isHidden = false
        }
        viewController.modalPresentationStyle = .fullScreen
        self.viewController?.present(viewController, animated: true, completion: nil)
    }

    func openStatistic() {
        let controller = AnimalsStatisticViewController.instantiate(fromStoryboard: .animals)
        guard var dataStore = controller.router?.dataStore else { return }
        dataStore.isEasy = !LocalStore.animalsIsHard
        presentNextChild(viewController: controller)
    }

    func navigateMain() {
        pushChild(viewControllerClass: AnimalsMainViewController.self, storyboard: .animals)
    }

    func dismiss() {
        viewController?.dismiss(animated: true)
    }

    func startFlow(_ idx: Int) {
        guard let controller = viewController else { return }

        let flow = AnimalsGameFlow(master: controller)
        flow.startFlow(idx)
    }

    /**
     Clean hierarchy
     */
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
		viewController.didMove(toParent: self.viewController)
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
