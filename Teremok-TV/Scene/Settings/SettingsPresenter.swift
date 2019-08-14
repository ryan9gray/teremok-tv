//
//  SettingsPresenter.swift
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

protocol SettingsPresentationLogic: CommonPresentationLogic {
    func presentProfile(_ model: Profile)
    func presentPromo(code: String)
    func activateState(_ state: String)

}

class SettingsPresenter: SettingsPresentationLogic {
    
    weak var viewController: SettingsDisplayLogic?
    
    var displayModule: CommonDisplayLogic? {
        return viewController
    }
    
    func presentProfile(_ model: Profile){
        viewController?.displayProfile(model)
    }
    func presentPromo(code: String){
        viewController?.setPromoCode(code: code)
    }

    func activateState(_ state: String) {
        present(errorString: state)
    }
}
