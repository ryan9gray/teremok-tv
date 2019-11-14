//
//  VideoItemsCommand.swift
//  Teremok-TV
//
//  Created by R9G on 05/09/2018.
//  Copyright © 2018 xmedia. All rights reserved.
//

import Foundation
import Alamofire

class VideoItemCommand: BasicCommand {
    let videoId: Int
    var razdId: Int?

    init(videoId: Int, razdId: Int?) {
        self.videoId = videoId
        self.razdId = razdId
    }
    
    func execute(success: ((VideoItemModel) -> Void)?, failure: ApiCompletionBlock?) {
        requestObject(success: success, failure: failure)
    }
    override var version: String {
        return "1.3"
    }

    override var method: String {
        return APIMethod.Content.videoItem.methodName
    }

    override var parameters: [String : Any] {
        var param = ["videoId": videoId ]
        if let razdId = razdId {
            param["razdId"] = razdId
        }
        return param
    }
}
