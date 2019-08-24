//
//  AlphabetGetStatCommand.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 10/08/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

import Alamofire

class AlphabetGetStatCommand: BasicCommand {

    func execute(success: ((AlphaviteStatisticResponse) -> Void)?, failure: ApiCompletionBlock?) {
        requestObject(success: success, failure: failure, path: "Stat")
    }

    override var method: String {
        return APIMethod.AlphabetGame.getStat.methodName
    }

    override var parameters: [String : Any] {
        return [ : ]
    }
}
