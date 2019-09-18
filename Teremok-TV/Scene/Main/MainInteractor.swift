//
//  MainInteractor.swift
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

protocol MainBusinessLogic {
    func getMainContent()
}

protocol MainDataStore {
    var mainRazdels: [RazdelModel] { get set }
}

class MainInteractor: MainBusinessLogic, MainDataStore {
    var presenter: MainPresentationLogic?

    let mainContentService: MainContentProtocol = MainContentService()
    var mainRazdels: [RazdelModel] = []
    
    
    func getMainContent(){
        mainContentService.getMain { [weak self] (result) in
            switch result {
            case .success(let mainContent):
                if let razdels = mainContent.razds {
                    self?.mainRazdels = razdels
                    self?.presenter?.presentMainRazdels(razdels)
                }
            case .failure(let error):
                self?.presenter?.presentError(error: error)
            }
        }
    }
}
