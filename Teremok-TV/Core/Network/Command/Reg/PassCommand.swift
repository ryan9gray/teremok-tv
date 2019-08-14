//
//  PassCommand.swift
//  Teremok-TV
//
//  Created by R9G on 15/09/2018.
//  Copyright © 2018 xmedia. All rights reserved.
//

import Foundation
import Alamofire

class ResetPassCommand: BasicCommand {
    let newPass: String
    let oldPass: String
    
    init(newPass: String, oldPass: String) {
        self.newPass = newPass
        self.oldPass = oldPass
    }
    
    func execute(completion: (() -> Void)?, failure: ApiCompletionBlock?) {
        requestOperation(success: completion, failure: failure)
    }
    
    override var method: String {
        return APIMethod.Users.auth.methodName
    }
    override var httpMethod: Alamofire.HTTPMethod {
        return .patch
    }
    override var isSigninRequest: Bool {
        return true
    }
    
    override var parameters: [String : Any] {
        
        return ["newpass":newPass, "oldpass":oldPass]
    }
}
class RestorePassCommand: BasicCommand {
    let email: String
    let newPass: String
    let code: String

    init(email: String, newPass: String, code: String) {
        self.email = email
        self.newPass = newPass
        self.code = code

    }
    
    func execute(completion: (() -> Void)?, failure: ApiCompletionBlock?) {
        requestOperation(success: completion, failure: failure)
    }
    
    override var method: String {
        return APIMethod.Users.restorePassword.methodName
    }
    override var httpMethod: Alamofire.HTTPMethod {
        return .put
    }
    override var isSigninRequest: Bool {
        return true
    }
    
    override var parameters: [String : Any] {
        return ["email": email, "newpass": newPass, "code": code]
    }
}

class RestorePassQueryCommand: BasicCommand {
    let email: String

    init(email: String) {
        self.email = email
    }

    func execute(completion: (() -> Void)?, failure: ApiCompletionBlock?) {
        requestOperation(success: completion, failure: failure)
    }

    override var method: String {
        return APIMethod.Users.restorePasswordQuery.methodName
    }
    override var isSigninRequest: Bool {
        return true
    }
    override var parameters: [String : Any] {
        return ["email": email]
    }
}

class CheckCodeCommand: BasicCommand {
    let email: String
    let code: String

    init(email: String, code: String) {
        self.email = email
        self.code = code
    }

    func execute(completion: (() -> Void)?, failure: ApiCompletionBlock?) {
        requestOperation(success: completion, failure: failure)
    }

    override var method: String {
        return APIMethod.Users.checkCode.methodName
    }
    override var httpMethod: Alamofire.HTTPMethod {
        return .put
    }
    override var isSigninRequest: Bool {
        return true
    }

    override var parameters: [String : Any] {
        return ["email": email, "code": code]
    }
}
