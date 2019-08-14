//
//  EditChildCommand.swift
//  Teremok-TV
//
//  Created by R9G on 24/09/2018.
//  Copyright © 2018 xmedia. All rights reserved.
//

import Foundation


class EditChildCommand: BasicCommand {
    let childId: String
    let childName: String
    let birthDate: String
    let sex: String

    init(childId: String, childName: String, birthDate: String, sex: String) {
        self.childId = childId
        self.childName = childName
        self.birthDate = birthDate
        self.sex = sex
    }
    
    func execute(success: ((EditChildResponse) -> Void)?, failure: ApiCompletionBlock?) {
        requestObject(success: success, failure: failure)
    }
    
    override var method: String {
        return APIMethod.Profile.editChild.methodName
    }
    
    override var parameters: [String : Any] {
        return ["childId": childId, "childName": childName, "birthDate": birthDate, "sex": sex]
    }
}
