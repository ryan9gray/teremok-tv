//
//  MusicMain.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 27/03/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

import Alamofire

class MusicMainCommand: BasicCommand {
    let itemsOnPage: Int
    let shiftItem: Int

    init(itemsOnPage: Int, shiftItem: Int) {
        self.itemsOnPage = itemsOnPage
        self.shiftItem = shiftItem
    }

    func execute(success: ((MusicContentResponse) -> Void)?, failure: ApiCompletionBlock?) {
        requestObject(success: success, failure: failure)
    }

    override var method: String {
        return APIMethod.Music.main.methodName
    }

    override var parameters: [String : Any] {

        return [ "itemsOnPage": itemsOnPage, "shiftItem": shiftItem ]
    }
}
