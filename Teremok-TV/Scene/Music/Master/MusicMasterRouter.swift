//
//  MusicMasterRouter.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 16/03/2019.
//  Copyright (c) 2019 xmedia. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol MusicParentProtocol {
    var childControllersStack: Stack<MusicViewController> { get set }
    var childVC: MusicViewController?  { get set }
    func canPop() -> Bool
    func pushChild(_ vc: MusicViewController)
    func pushChild<T: MusicViewController>(viewControllerClass: T.Type, storyboard: StoryboardWorker)
    func presentNextChild<T: MusicViewController>(viewController: T)
    func popChild()
    var viewController: MusicMasterViewController? { get set }
}

protocol MusicMasterRoutingLogic: CommonRoutingLogic, MusicParentProtocol {
    func navigateMain()
    func navigateToSearch()
}

protocol MusicMasterDataPassing {
    var dataStore: MusicMasterDataStore? { get }
}

class MusicMasterRouter: NSObject, MusicMasterRoutingLogic, MusicMasterDataPassing {
    weak var viewController: MusicMasterViewController?
    var dataStore: MusicMasterDataStore?
    var modalControllersQueue = Queue<UIViewController>()

    func navigateMain() {
        pushChild(viewControllerClass: AlbumViewController.self, storyboard: .music)
    }

    func navigateToSearch() {
        let search = SearchMusicViewController.instantiate(fromStoryboard: .music)
        presentNextChild(viewController: search)
    }

    // Parent
    var childControllersStack = Stack<MusicViewController>()

    func pushChild(_ vc: MusicViewController){
        remove()
        childControllersStack.toEmpty()
        add(asChildViewController: vc)
    }

    func canPop() -> Bool {
        return childControllersStack.count > 1
    }

    var childVC: MusicViewController? {
        set {
            guard let value = newValue else { return }
            childControllersStack.push(value)
        }
        get {
            return childControllersStack.top
        }
    }

    func pushChild<T: MusicViewController>(viewControllerClass: T.Type, storyboard: StoryboardWorker = .main){
        remove()
        childControllersStack.toEmpty()
        add(asChildViewController: viewControllerClass.instantiate(fromStoryboard: storyboard))
    }

    func add(asChildViewController viewController: MusicViewController) {
        viewController.masterRouter = self
        childVC = viewController
        self.viewController?.addChild(viewController)
        presentChild(viewController: viewController)
    }

    func presentChild(viewController: MusicViewController){
        UIView.transition(with: viewController.view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            // Add Child View as Subview
            self.viewController?.view.insertSubview(viewController.view, aboveSubview: (self.viewController?.backgroundView)!)
        }, completion: nil)

        viewController.view.frame = viewController.view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParent: viewController)
    }

    func remove(){
        guard let childVC = self.childVC else { return }

        remove(asChildViewController: childVC)
    }

    func remove(asChildViewController viewController: UIViewController) {
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }

    func presentNextChild<T: MusicViewController>(viewController: T){
        self.remove()
        self.add(asChildViewController: viewController)
    }

    func popChild(){
        guard let oldVC = childControllersStack.pop() else { return }
        self.remove(asChildViewController: oldVC)
        guard let vc = childControllersStack.top else { return }
        self.presentChild(viewController: vc)
    }
}
