//
//  MonsterMasterRouter.swift
//  Teremok-TV
//
//  Created by Дмитрий Грищенко on 14/08/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

import UIKit

protocol MonsterMasterRoutingLogic: GameParentRouting {
    func openStatistic()
}

protocol MonsterMasterDataPassing {
    var dataStore: MonsterMasterDataStore? { get }
}

class MonsterMasterRouter: MonsterMasterRoutingLogic, MonsterMasterDataPassing {
    weak var viewController: MonsterMasterViewController?
    var dataStore: MonsterMasterDataStore?
    var modalControllersQueue = Queue<UIViewController>()
    
    // MARK: Routing
    func openStatistic() {
        guard modalChildVC == nil else { return }
        
        let vc = MonsterStatisticViewController.instantiate(fromStoryboard: .monster)
        viewController?.presentAlertModally(alertController: vc)
    }
    
    func navigateMain() {
        pushChild(viewControllerClass: MonsterStartViewController.self, storyboard: .monster)
    }
    
    /**
     Clean hierarchy
     */
    func startFlow(_ idx: Int) {
        guard let controller = viewController else { return }
        
        viewController?.tipView?.dismiss()
        let flow = MonsterGameFlow(master: controller)
        flow.service = dataStore?.service
        flow.startFlow(difficulty: idx)
    }
    
    var moduleRouter: MasterModuleDisplayLogic? {
        return viewController
    }
    var childControllersStack = Stack<GameViewController>()
    var modalChildVC: GameViewController?
    
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
