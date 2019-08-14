//
//  GetAchievementsCommand .swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 23/01/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

import Alamofire

class GetAchievementsCommand: BasicCommand {

    func execute(success: (([AchievementsResponse]) -> Void)?, failure: ApiCompletionBlock?) {
        requestObjectArray(success: success, failure: failure, path: "achievements")
    }

    override var method: String {
        return APIMethod.Profile.getAchievements.methodName
    }
    override var version: String {
        return "1.1"
    }
    override var parameters: [String : Any] {
        return [:]
    }
}
