//
//  ChildCommand.swift
//  Teremok-TV
//
//  Created by R9G on 11/09/2018.
//  Copyright © 2018 xmedia. All rights reserved.
//

import Foundation

class AddChildCommand: BasicCommand {
    let childName: String
    let birthDate: String
    let sex: String
    let base64pic: String?
    
    init(childName: String, birthDate: String, sex: String, base64pic: String?) {
        self.childName = childName
        self.birthDate = birthDate
        self.sex = sex
        self.base64pic = base64pic
    }
    
    func execute(success: ((AddChildResponse) -> Void)?, failure: ApiCompletionBlock?) {
        requestObject(success: success, failure: failure)
    }
    
    override var method: String {
        return APIMethod.Profile.addChild.methodName
    }
    
    override var parameters: [String : Any] {
        return ["childName": childName, "birthDate": birthDate, "sex": sex, "base64pic": base64pic ?? ""]
    }
}


