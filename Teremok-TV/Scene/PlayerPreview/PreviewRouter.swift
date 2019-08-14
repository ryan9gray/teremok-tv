//
//  PreviewRouter.swift
//  Teremok-TV
//
//  Created by R9G on 05/09/2018.
//  Copyright (c) 2018 xmedia. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol PreviewRoutingLogic: CommonRoutingLogic {
    func navigateToPreview(number: Int)
}

protocol PreviewDataPassing {
    var dataStore: PreviewDataStore? { get }
}

class PreviewRouter: NSObject, PreviewRoutingLogic, PreviewDataPassing {
    weak var viewController: PreviewViewController?
    var dataStore: PreviewDataStore?
    
    var modalControllersQueue = Queue<UIViewController>()

    // MARK: Routing
    func navigateToPreview(number: Int){
        let serials = PreviewViewController.instantiate(fromStoryboard: .play)
        guard var dataStore = serials.router?.dataStore else { return }
        guard let id = viewController?.router?.dataStore?.videoItem?.recommendations?[safe: number]?.id else {
            return
        }
        dataStore.model = .online(id: id)
        viewController?.masterRouter?.presentNextChild(viewController: serials)
    }

}
