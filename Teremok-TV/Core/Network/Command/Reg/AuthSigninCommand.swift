//
//  AuthSigninCommand.swift
//  vapteke
//
//  Created by R9G on 28.06.2018.
//  Copyright © 2018 550550. All rights reserved.
//

import Foundation
import Alamofire

class AuthCommand: BasicCommand {
    let userEmail: String
    let userPass: String
    
    init(userEmail: String, userPass: String) {
        self.userEmail = userEmail
        self.userPass = userPass
    }
    
    func execute(success: ((RegistrResponse) -> Void)?, failure: ApiCompletionBlock?) {
        requestObject(success: success, failure: failure)
    }
    
    override var method: String {
        return APIMethod.Users.auth.methodName
    }
    override var isSigninRequest: Bool {
        return true
    }
    
    override var parameters: [String : Any] {
        return ["email":userEmail, "pass":userPass]
    }
}

class RegCommand: BasicCommand {
    let childName: String
    let userEmail: String
    let userPass: String
    let birthDate: String
    var base64pic: String?
    
    /** Пол */
    let sex: String
    
    init(childName: String, userEmail: String, userPass: String, birthDate: String, sex: String, base64pic: String?) {
        self.userEmail = userEmail
        self.userPass = userPass
        self.childName = childName
        self.birthDate = birthDate
        self.sex = sex
        self.base64pic = base64pic
    }
    
    func execute(success: ((RegistrResponse) -> Void)?, failure: ApiCompletionBlock?) {
        requestObject(success: success, failure: failure)
    }
    
    override var method: String {
        return APIMethod.Users.userRegistration.methodName
    }
    
    override var isSigninRequest: Bool {
        return true
    }
    
    override var parameters: [String : Any] {
        return ["childName": childName, "userEmail": userEmail, "userPass": userPass, "childBirthDate": birthDate, "childSex": sex, "base64pic": base64pic ?? ""]
    }

}
class CheckEmailCommand: BasicCommand {
    let email: String
    
    init(email: String) {
        self.email = email
    }
    
    func execute(success: ((StateResponse) -> Void)?, failure: ApiCompletionBlock?) {
        requestObject(success: success, failure: failure)
    }
    
    override var method: String {
        return APIMethod.Users.checkEMail.methodName
    }

    override var isSigninRequest: Bool {
        return true
    }
    
    override var parameters: [String : Any] {
        return ["email":email]
    }
}
class LogoutCommand: BasicCommand {
    
    func execute(success: (() -> Void)?, failure: ApiCompletionBlock?) {
        requestOperation(success: success, failure: failure)
    }
    
    override var method: String {
        return APIMethod.Users.logout.methodName
    }

    
    override var parameters: [String : Any] {
        return [:]
    }
}
