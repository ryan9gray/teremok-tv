//
//  SearchRouter.swift
//  Teremok-TV
//
//  Created by R9G on 12/10/2018.
//  Copyright (c) 2018 xmedia. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol SearchRoutingLogic: CommonRoutingLogic {
    func navigateToSerial(id: Int)
    func navigateToRazdel(search: String)

}

protocol SearchDataPassing {
    var dataStore: SearchDataStore? { get }
}

class SearchRouter: NSObject, SearchRoutingLogic, SearchDataPassing {
    weak var viewController: SearchViewController?
    var dataStore: SearchDataStore?
    var modalControllersQueue = Queue<UIViewController>()

    // MARK: Routing

    func navigateToSerial(id: Int) {
        let serials = SerialViewController.instantiate(fromStoryboard: .main)
        guard var dataStore = serials.router?.dataStore else { return }
        dataStore.screen = .razdel(id)
        //dataStore.razdelTitle = title
        viewController?.masterRouter?.presentNextChild(viewController: serials)
    }

    func navigateToRazdel(search: String) {
        let serials = SerialViewController.instantiate(fromStoryboard: .main)
        guard var dataStore = serials.router?.dataStore else { return }
        dataStore.screen = .search(search)
        dataStore.razdelTitle = "Результаты поиска"
        viewController?.masterRouter?.presentNextChild(viewController: serials)
    }
}
