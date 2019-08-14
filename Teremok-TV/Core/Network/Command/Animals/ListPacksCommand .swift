//
//  ListPacksCommand .swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 31/05/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

import Alamofire

class ListPacksCommand: CacheableCommand {

    override init() {
        super.init()
        self.shoudRemoveCach = false
        self.shouldUseCache = true
        self.expirationInterval = CacheExpiration.hour
    }

    func execute(success: ((AnimalsListResponse) -> Void)?, failure: ApiCompletionBlock?) {
        requestObject(success: success, failure: failure)
    }

    override var method: String {
        return APIMethod.AnimalsGame.listPacks.methodName
    }

    override var parameters: [String : Any] {
        return [ : ]
    }
}
