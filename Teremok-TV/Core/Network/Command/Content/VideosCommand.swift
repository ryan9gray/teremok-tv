//
//  VideosCommand.swift
//  Teremok-TV
//
//  Created by R9G on 05/09/2018.
//  Copyright © 2018 xmedia. All rights reserved.
//

import Alamofire

class VideosCommand: BasicCommand {
    let itemsOnPage: Int
    let shiftItem: Int
    let seriesId: Int

    init(itemsOnPage: Int, shiftItem: Int, seriesId: Int) {
        self.itemsOnPage = itemsOnPage
        self.shiftItem = shiftItem
        self.seriesId = seriesId
    }
    func execute(success: ((VideoResponse) -> Void)?, failure: ApiCompletionBlock?) {
        requestObject(success: success, failure: failure)
    }
//    override var version: String {
//        return "1.1"
//    }

    override var method: String {
        return APIMethod.Content.videos.methodName
    }
    
    override var parameters: [String : Any] {
        return ["itemsOnPage": itemsOnPage, "shiftItem": shiftItem, "seriesId": seriesId]
    }
}
