//
//  GetProfileCommand.swift
//  Teremok-TV
//
//  Created by R9G on 11/09/2018.
//  Copyright © 2018 xmedia. All rights reserved.
//

import Foundation
import Alamofire

class GetProfileCommand: BasicCommand {

    var isNewSession: Bool

    init(isNewSession: Bool = false) {
        self.isNewSession = isNewSession
    }

    func execute(success: ((GetProfileResponse) -> Void)?, failure: ApiCompletionBlock?) {
        requestObject(success: success, failure: failure)
    }
    
    override var method: String {
        return APIMethod.Profile.getProfile.methodName
    }
    override var version: String {
        return "1.2"
    }
    override var parameters: [String : Any] {
        return ["isNewSession": isNewSession]
    }    
}
