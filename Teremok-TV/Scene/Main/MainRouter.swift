//
//  MainRouter.swift
//  Teremok-TV
//
//  Created by R9G on 22.08.2018.
//  Copyright (c) 2018 xmedia. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol MainRoutingLogic: CommonRoutingLogic {
    func navigateToRazdel(number: Int)
}

protocol MainDataPassing {
    var dataStore: MainDataStore? { get }
}

class MainRouter: NSObject, MainRoutingLogic, MainDataPassing {
    
    weak var viewController: MainViewController?
    var dataStore: MainDataStore?
    
    var modalControllersQueue = Queue<UIViewController>()


    func navigateToRazdel(number: Int){
        let razdel = viewController?.router?.dataStore?.mainRazdels[safe: number]
        guard let type = razdel?.itemType, type == .series else {
            navigateToVideos(razdelId: razdel?.razdId ?? 0)
            return
        }
        let serials = RazdelViewController.instantiate(fromStoryboard: .main)
        guard var dataStore = serials.router?.dataStore else { return }
        if let id = razdel?.razdId {
            dataStore.razdelId = razdel?.razdId
            dataStore.screen = .razdel(id)
        }
        viewController?.masterRouter?.presentNextChild(viewController: serials)
    }
    func navigateToVideos(razdelId: Int){
        let serials = SerialViewController.instantiate(fromStoryboard: .main)
        guard var dataStore = serials.router?.dataStore else { return }
        dataStore.razdelId = razdelId
        dataStore.screen = .razdel(razdelId)
        viewController?.masterRouter?.presentNextChild(viewController: serials)
    }
}
