//
//  AuthPresenter.swift
//  Teremok-TV
//
//  Created by R9G on 10.08.2018.
//  Copyright (c) 2018 xmedia. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol AuthPresentationLogic: CommonPresentationLogic {
    func presentMain()
}

class AuthPresenter: AuthPresentationLogic {
    weak var viewController: AuthDisplayLogic?
    var displayModule: CommonDisplayLogic? {
        return viewController
    }
    
    func presentMain(){
        self.viewController?.displayMain()
    }
        
}
