//
//  DinoGetStatCommand.swift
//  Teremok-TV
//
//  Created by Виктор Пузаков on 13.04.2020.
//  Copyright © 2020 xmedia. All rights reserved.
//

import Alamofire

class DinoGetStatCommand: BasicCommand {

    func execute(success: ((DinoStatisticResponse) -> Void)?, failure: ApiCompletionBlock?) {
        requestObject(success: success, failure: failure, path: "Stat")
    }
    
    override var method: String {
        return APIMethod.DinosaursGame.getStat.methodName
    }
    
    override var parameters: [String : Any] {
        return [ : ]
    }
}
