//
//  MasterRouter.swift
//  Teremok-TV
//
//  Created by R9G on 16/09/2018.
//  Copyright (c) 2018 xmedia. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ParentRoutingLogic {
    var childControllersStack: Stack<AbstracViewController> { get set }
    var childVC: AbstracViewController?  { get set }
    func canPop() -> Bool
    func pushChild(_ vc: AbstracViewController)
    func pushChild<T: AbstracViewController>(viewControllerClass: T.Type, storyboard: StoryboardWorker)
    func presentNextChild<T: AbstracViewController>(viewController: T)
    func popChild()
}

protocol MasterRoutingLogic: CommonRoutingLogic, ParentRoutingLogic {
    func navigateToReg()
    func navigateToAuth()
    func logout()
    func navigateToSettings()
    func navigateToStore()
}

protocol MasterVCRoutingLogic: MasterRoutingLogic {
    func navigateToAchieves()
    func navigateToFav()
    func navigateToSearch()
    func navigateToMain()
    func navigateToVideo(id: Int)
    func navigateToAddChild()
    func navigateToMusic()
    func navigateToGameList()
    func navigateToAnimals()
}

protocol MasterDataPassing {
    var dataStore: MasterDataStore? { get }
}

final class MasterRouter: NSObject, MasterVCRoutingLogic, MasterDataPassing {
    weak var viewController: MasterViewController?
    var dataStore: MasterDataStore?
    var modalControllersQueue = Queue<UIViewController>()

    func navigateToMain(){
        viewController?.isKidsPlusShow = true
        viewController?.prepareBackground()
        pushChild(viewControllerClass: MainViewController.self, storyboard: .main)
    }

    func navigateToAddChild(){
        let vc = ChildProfileAddViewController.instantiate(fromStoryboard: .autorization)
        guard var dataStore = vc.router?.dataStore else { return }
        dataStore.screen = .Add
        pushChild(vc)
    }

    func navigateToFav(){
        let vc = FavViewController.instantiate(fromStoryboard: .main)
        pushChild(vc)
    }

    func navigateToGameList() {
        let vc = GamesListViewController.instantiate(fromStoryboard: .common)
        vc.output = GamesListViewController.Output(
            openAnimals: navigateToAnimals,
            openAlphavite: navigateToAlphavite,
            openMonster: navigateToMonster
        )
        viewController?.present(vc, animated: true, completion: nil)
    }

    func navigateToAlphavite() {
        let vc = AlphaviteMasterViewController.instantiate(fromStoryboard: .alphavite)
        vc.output = AlphaviteMasterViewController.Output(
            openSettings: navigateToSettings,
            openAuthorization: navigateToReg
        )
        viewController?.present(vc, animated: true, completion: nil)
    }

    func navigateToMusic() {
        let music = MusicMasterViewController.instantiate(fromStoryboard: .music)
        music.output = MusicMasterViewController.Output(openSettings: navigateToSettings, openAuthorization: navigateToReg)
        viewController?.present(music, animated: true, completion: nil)
    }

    func navigateToAnimals() {
        let animals = AnimalsMasterViewController.instantiate(fromStoryboard: .animals)
        animals.output = AnimalsMasterViewController.Output(openSettings: navigateToSettings, openAuthorization: navigateToReg)
        viewController?.present(animals, animated: true, completion: nil)
    }

    func navigateToMonster() {
        let vc = MonsterMasterViewController.instantiate(fromStoryboard: .monster)
        vc.output = MonsterMasterViewController.Output(
            openSettings: navigateToSettings,
            openAuthorization: navigateToReg
        )
        viewController?.present(vc, animated: true, completion: nil)
    }

    /// Deprecate
    func navigateToCatalog(){
        let serials = RazdelViewController.instantiate(fromStoryboard: .main)
        pushChild(serials)
    }

    func navigateToAchieves(){
        let vc = AchievesViewController.instantiate(fromStoryboard: .main)
        pushChild(vc)
    }

    func navigateToSearch(){
        let search = SearchViewController.instantiate(fromStoryboard: .main)
        pushChild(search)
    }

    func navigateToSettings(){
        let vc = SecurityCodeViewController.instantiate(fromStoryboard: .common)
        vc.screen = .settings
        pushChild(vc)
    }

    func navigateToVideo(id: Int){
        let vc = PreviewViewController.instantiate(fromStoryboard: .play)
        guard var dataStore = vc.router?.dataStore else { return }
        dataStore.model = .online(id: id)
        pushChild(vc)
    }

    func navigateToStore(){
        let code = SecurityCodeViewController.instantiate(fromStoryboard: .common)
        code.screen = .store
        pushChild(code)
    }

    // MARK: Master Routing
    func navigateToAuth() {
        viewController?.isKidsPlusShow = false
        let vc = AuthViewController.instantiate(fromStoryboard: .autorization)
        pushChild(vc)
    }

    func navigateToReg(){
        viewController?.isKidsPlusShow = false
        let vc = RegistrationViewController.instantiate(fromStoryboard: .autorization)
        pushChild(vc)
    }

    func logout(){
        viewController?.logout()
        navigateToReg()
    }

    var  childControllersStack = Stack<AbstracViewController>()

    func pushChild(_ vc: AbstracViewController){
        remove()
        childControllersStack.toEmpty()
        add(asChildViewController: vc)
    }

    func canPop() -> Bool {
        return childControllersStack.count > 1
    }

    var childVC: AbstracViewController? {
        set{
            guard let value = newValue else { return }
            childControllersStack.push(value)
        }
        get{
            return childControllersStack.top
        }
    }

    func pushChild<T: AbstracViewController>(viewControllerClass: T.Type, storyboard: StoryboardWorker = .main){
        remove()
        childControllersStack.toEmpty()
        add(asChildViewController: viewControllerClass.instantiate(fromStoryboard: storyboard))
    }
    
    func add(asChildViewController viewController: AbstracViewController) {
        viewController.masterRouter = self
        childVC = viewController
        self.viewController?.addChild(viewController)
        presentChild(viewController: viewController)
    }
    
    func presentChild(viewController: AbstracViewController){

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

    func remove(asChildViewController viewController: AbstracViewController) {
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }

    func presentNextChild<T: AbstracViewController>(viewController: T){
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
