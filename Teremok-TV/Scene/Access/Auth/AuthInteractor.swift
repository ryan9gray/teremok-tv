//
//  AuthInteractor.swift
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

protocol AuthBusinessLogic {
    func authorization(userEmail: String, userPass: String)
}

protocol AuthDataStore {

}

class AuthInteractor: AuthBusinessLogic, AuthDataStore {
    var presenter: AuthPresentationLogic?
    let service: AuthProtocol = AuthService()
    lazy var keychainService: KeychainService = MainKeychainService()
    
    func authorization(userEmail: String, userPass: String){
        service.toAuth(userEmail: userEmail, userPass: userPass){ [weak self] (check) in
            switch check {
            case .success(let response):
                if let token = response.uToken {
                    self?.keychainService.saveAuthSession(session: token)
                    self?.presenter?.presentMain()
                    NotificationCenter.default.post(name: .ProfileNeedReload, object: nil)
                }
            case .failure(let er):
                self?.presenter?.present(errorString: er.localizedDescription, completion: nil)
            }
        }
    }

    // MARK: Do something

}