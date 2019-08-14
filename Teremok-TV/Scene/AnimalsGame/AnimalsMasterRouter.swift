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
    
}

protocol AnimalsMasterDataPassing {
    var dataStore: AnimalsMasterDataStore? { get }
}

class AnimalsMasterRouter: AnimalsMasterRoutingLogic, AnimalsMasterDataPassing {
    weak var viewController: AnimalsMasterViewController?

    var dataStore: AnimalsMasterDataStore?
    var modalControllersQueue = Queue<UIViewController>()

    var isEasy: Bool {
        return dataStore?.isEasy ?? true
    }
    // Parent

    func navigateMain() {
        pushChild(viewControllerClass: AnimalsMainViewController.self, storyboard: .animals)
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
    var modalChildVC: GameViewController?

    func introduceController<T: GameViewController>(viewController: T, completion: @escaping () -> Void)
        where T: IntroduceViewController {
            viewController.setAction {
                completion()
            }
            presentModalChild(viewController: viewController)
    }

    var childControllersStack = Stack<GameViewController>()

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

        viewController.view.frame = viewController.view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParent: viewController)
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