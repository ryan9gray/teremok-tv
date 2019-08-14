//
//  SwithChildeCommand.swift
//  Teremok-TV
//
//  Created by R9G on 11/09/2018.
//  Copyright © 2018 xmedia. All rights reserved.
//

import Foundation
import Alamofire

class SwitchChildCommand: BasicCommand {
    let childId: String

    init(childId: String) {
        self.childId = childId
    }
    
    func execute(success: ((GetProfileResponse) -> Void)?, failure: ApiCompletionBlock?) {
        requestObject(success: success, failure: failure)
    }
    
    override var method: String {
        return APIMethod.Profile.switchChild.methodName
    }
    override var parameters: [String : Any] {
        return ["childID": childId]
    }
    
}
class UploadPicCommand: BasicCommand {
    let base64pic: String
    
    init(base64pic: String){
        self.base64pic = base64pic
    }
    
    func execute(success: ((StateResponse) -> Void)?, failure: ApiCompletionBlock?) {
        requestObject(success: success, failure: failure)
    }
    
    override var method: String {
        return APIMethod.Profile.uploadUserPic.methodName
    }
    override var httpMethod: Alamofire.HTTPMethod {
        return .put
    }

    override var parameters: [String : Any] {
        return ["base64pic":base64pic]
    }
    
}
class DeleteChildCommand: BasicCommand {
    let id: String
    
    init(id: String) {
        self.id = id
    }

    func execute(success: ((StateResponse) -> Void)?, failure: ApiCompletionBlock?) {
        requestObject(success: success, failure: failure)
    }
    
    override var method: String {
        return APIMethod.Profile.deleteChild.methodName
    }
    override var httpMethod: Alamofire.HTTPMethod {
        return .delete
    }

    override var parameters: [String : Any] {
        return ["id": id]
    }
    
}
