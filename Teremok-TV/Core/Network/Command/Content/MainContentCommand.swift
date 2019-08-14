//
//  MainContendCommand.swift
//  Teremok-TV
//
//  Created by R9G on 02/09/2018.
//  Copyright © 2018 xmedia. All rights reserved.
//

import Alamofire


class MainContentCommand: BasicCommand {

    func execute(success: ((MainContentResponse) -> Void)?, failure: ApiCompletionBlock?) {
        requestObject(success: success, failure: failure)
    }

    override var method: String {
        return APIMethod.Content.main.methodName
    }
 
    override var parameters: [String : Any] {
        return [:]
    }
}