//
//  MonsterSendStatCommand.swift
//  Teremok-TV
//
//  Created by Дмитрий Грищенко on 04/09/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

import Alamofire

class MonsterSendStatCommand: BasicCommand {
    let stats: [MonsterStatisticRequest]
    
    init(stats: [MonsterStatisticRequest]) {
        self.stats = stats
    }
    func execute(success: ((StatusResponse) -> Void)?, failure: ApiCompletionBlock?) {
        requestObject(success: success, failure: failure)
    }
    
    override var method: String {
        return APIMethod.MonsterGame.sendStat.methodName
    }
    
    override var parameters: [String : Any] {
        return [ "Stats" : stats.map { $0.toJSON() } ]
    }
}
