//
//  SettingsInteractor.swift
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
import SwiftyStoreKit

protocol SettingsBusinessLogic {
    func fetchData()
    func logout()
}

protocol SettingsDataStore {
    var isAuth: Bool {get set}
    var isPremium: Bool {get set}
}

class SettingsInteractor: SettingsBusinessLogic, SettingsDataStore {
    var presenter: SettingsPresentationLogic?
    let service: ProfileProtocol = ProfileService()
    let purchaseService: PurchaseProtocol = PurchaseService()
	let storeService: SwiftyStorePorotocol = SwiftyStoreHelper()
	let logoutService: LogoutProtocol = LogoutService()
    
    var isAuth: Bool = false
    var isPremium: Bool = false

    func fetchData(){
        getProfile()

//        DispatchQueue.global(qos: .utility).async {
//            self.getPromo()
//        }
//        if let profile = Profile.current {
//            self.presenter?.presentProfile(profile)
//        }
//        else {
//            getProfile()
//        }
//        storeService.info { [weak self] price in
//            self?.presenter?.presentProduct(price)
//        }
    }
    func logout(){
        logoutService.logout()
		getProfile()
    }
    
    func getProfile() {
        service.getProfile { [weak self] (result) in
            switch result {
            case .success(let response):
                if let profileResp = response.profile {
                    let profile = Profile(with: profileResp)
                    AppCacher.mappable.saveObject(profile)
                    Profile.current = profile
                    self?.presenter?.presentProfile(profile)
                }
            case .failure(let error):
                self?.presenter?.presentError(error: error)
            }
        }
    }
}
