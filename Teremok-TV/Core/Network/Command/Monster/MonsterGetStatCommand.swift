//
//  MonsterGetStatCommand.swift
//  Teremok-TV
//
//  Created by Дмитрий Грищенко on 04/09/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

import Alamofire

class MonsterGetStatCommand: BasicCommand {

    func execute(success: ((MonsterStatisticResponse) -> Void)?, failure: ApiCompletionBlock?) {
        requestObject(success: success, failure: failure, path: "Stat")
    }
    
    override var method: String {
        return APIMethod.MonsterGame.getStat.methodName
    }
    
    override var parameters: [String : Any] {
        return [ : ]
    }
}
