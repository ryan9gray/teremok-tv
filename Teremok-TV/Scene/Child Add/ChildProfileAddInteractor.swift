//
//  ChildProfileAddInteractor.swift
//  Teremok-TV
//
//  Created by R9G on 30/08/2018.
//  Copyright (c) 2018 xmedia. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ChildProfileAddBusinessLogic {
    func done(name: String, birthDate: String, sex: Sex, avatar: UIImage?)
    func choosed(birthday: Date)
    func fillChild()
}

protocol ChildProfileAddDataStore {
    var password: String? {get set }
    var email: String? {get set }
    var child: Child? {get set }
    var screen: ChildProfileAdd.Screen? {get set}

}

final class ChildProfileAddInteractor: ChildProfileAddBusinessLogic, ChildProfileAddDataStore {
    
    var screen: ChildProfileAdd.Screen?
    var child: Child?

    var password: String?
    var email: String?
    
    var presenter: ChildProfileAddPresentationLogic?

    
    let authService: RegProtocol = RegService()
    let childService: ChildProtocol = ChildService()
    
    lazy var keychainService: KeychainService = MainKeychainService()

    var requestSynchronizer = DispatchGroup()
    private var synchronizedRequestErrors = Set<String>()

    func choosed(birthday: Date) {
        presenter?.present(date: birthday)
    }
    func fillChild(){
        
        guard let screen = self.screen else {
            return
        }
        switch screen {
        case .Modify(let child):
            self.child = child
            if let child = self.child {
                presenter?.presentChild(child)
            }
        default:
            break
        }
    }
    

    func uploadAvatar(base64pic: String){
        requestSynchronizer.enter()
        childService.uploudAvatar(pic: base64pic) { [weak self] (result) in
            switch result {
            case .success(let resp):
                print("upload is \(resp)")
            case .failure(let er):
                self?.presenter?.present(errorString: er.localizedDescription, completion: nil)
            }
            self?.requestSynchronizer.leave()
        }
    }
    
    func done(name: String, birthDate: String, sex: Sex, avatar: UIImage?){
        
        guard let screen = self.screen else {
            return
        }
        let base64String = avatar?.base64()

        switch screen {
        case .Modify(_ ):
           modifyChild(name: name, birthDate: birthDate, sex: sex.rawValue, base64pic: base64String)
        case .Add:
            addChild(name: name, birthDate: birthDate, sex: sex.rawValue, base64pic: base64String)
        case .Registrate:
            guard let pass = self.password, let email = self.email else {
                print("no data")
                return
            }
            registration(childName: name, userEmail: email, userPass: pass, birthDate: birthDate, sex: sex.rawValue, base64pic: base64String)
        }
    }
    
    func modifyChild(name: String, birthDate: String, sex: String, base64pic: String?){
        if let avatar = base64pic {
            uploadAvatar(base64pic: avatar)
        }
        requestSynchronizer.enter()
        childService.editChild(id: self.child?.id ?? "", name: name, birthdate: birthDate, sex: sex) {[weak self] (res) in
            switch res {
            case .success(let response):
                if let child = response.childProfile {
                    self?.child = child//Child.init(with: child)
                }
            case .failure(let er):
                self?.presenter?.present(errorString: er.localizedDescription, completion: nil)
            }
            self?.requestSynchronizer.leave()
        }
        requestSynchronizer.notify(queue: .main) {
            self.showFinish()
            self.presentSynchonizedRequestsErrors()
        }
    }
    func addChild(name: String, birthDate: String, sex: String, base64pic: String?){
        
        childService.addChild(name: name, birthdate: birthDate, sex: sex, base64pic: base64pic){ [weak self] (res) in
            switch res {
            case .success(let response):
                if let child = response.childProfile {
                    self?.child = child//Child.init(with: child)
                }
                self?.showFinish()
            case .failure(let er):
                self?.presenter?.present(errorString: er.localizedDescription, completion: nil)
            }
        }
    }
    
    func registration(childName: String, userEmail: String, userPass: String, birthDate: String, sex: String, base64pic: String?){

        authService.postRegistrate(childName: childName, userEmail: userEmail, userPass: userPass, birthDate: birthDate, sex: sex, base64pic: base64pic) { [weak self](reg) in
            switch reg {
            case .success(let response):
                if let child = response.childProfile {
                    self?.child = child//Child.init(with: child)
                }
                if let token = response.uToken{
                    self?.keychainService.saveAuthSession(session: token)
                    NotificationCenter.default.post(name: .ProfileNeedReload, object: nil)
                    self?.showFinish()
                }
                else{
                    print("нет токена")
                }
            case .failure(let er):
                self?.presenter?.present(errorString: er.localizedDescription, completion: nil)
            }
        }
    }

    func showFinish() {
        self.presenter?.presentFinish()
    }
    
    private func presentSynchonizedRequestsErrors() {
        for error in self.synchronizedRequestErrors {
            self.presenter?.present(errorString: error, completion: nil)
        }
        self.synchronizedRequestErrors.removeAll()
    }
    
}