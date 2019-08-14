//
//  AnimalsGetStat.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 12/06/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

import Alamofire

class AnimalsGetStatCommand: BasicCommand {
    func execute(success: ((AnimalsStatResponse) -> Void)?, failure: ApiCompletionBlock?) {
        requestObject(success: success, failure: failure)
    }

    override var method: String {
        return APIMethod.AnimalsGame.getStat.methodName
    }

    override var parameters: [String : Any] {
        return [:]
    }
}
