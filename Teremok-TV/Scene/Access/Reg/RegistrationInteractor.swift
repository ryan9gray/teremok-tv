//
//  RegistrationInteractor.swift
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

protocol RegistrationBusinessLogic {
    func checkEmail(email:String)
    func validatePassFields(text: String) -> Bool

}

protocol RegistrationDataStore {
    
}

class RegistrationInteractor: RegistrationBusinessLogic, RegistrationDataStore {
    var presenter: RegistrationPresentationLogic?
    
    var authService: RegProtocol = RegService()
    lazy var keychainService: KeychainService = MainKeychainService()

    
    func checkEmail(email:String){
        authService.checkEmail(email: email) {  [weak self] (check) in
            switch check {
            case .success(let response):
                if let state = response.state {
                    print(state)
                    self?.presenter?.presentChildAdd()
                }
            case .failure(let er):
                self?.presenter?.present(errorString: er.localizedDescription, completion: nil)
            }
        }
    }
    func validatePassFields(text: String) -> Bool {
 
        guard text.count >= 5 else {
            self.presenter?.present(errorString: "Пароль должен быть длинной не меньше 5 символов", completion: nil)
            return false
        }
        return true
    }

    // MARK: Do something

}
