//
//  DinoSendStatCommand.swift
//  Teremok-TV
//
//  Created by Виктор Пузаков on 13.04.2020.
//  Copyright © 2020 xmedia. All rights reserved.
//

import Alamofire

class DinoSendStatCommand: BasicCommand {
    let stats: DinoStatisticRequest
    
    init(stats: DinoStatisticRequest) {
        self.stats = stats
    }
    func execute(success: ((StatusResponse) -> Void)?, failure: ApiCompletionBlock?) {
        requestObject(success: success, failure: failure)
    }
    
    override var method: String {
        return APIMethod.DinosaursGame.sendStat.methodName
    }
    
    override var parameters: [String : Any] {
        return [
            "Stats" : stats.toJSON()
        ]
    }
}
