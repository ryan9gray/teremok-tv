//
//  colorsGameGetStatCommand.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 05/10/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

import Alamofire

class ColorsGameGetStatCommand: BasicCommand {

    func execute(success: ((AlphaviteStatisticResponse) -> Void)?, failure: ApiCompletionBlock?) {
        requestObject(success: success, failure: failure, path: "Stat")
    }

    override var method: String {
        return APIMethod.ColorsGame.getStat.methodName
    }

    override var parameters: [String : Any] {
        return [ : ]
    }
}

class ColorsGameSendStatCommand: BasicCommand {
    let stats: [AlphaviteStatistic]

    init(stats: [AlphaviteStatistic]) {
        self.stats = stats
    }
    func execute(success: ((StatusResponse) -> Void)?, failure: ApiCompletionBlock?) {
        requestObject(success: success, failure: failure)
    }

    override var method: String {
        return APIMethod.ColorsGame.sendStat.methodName
    }

    override var parameters: [String : Any] {
        return [ "Stats" : stats.map { $0.toJSON() } ]
    }
}
