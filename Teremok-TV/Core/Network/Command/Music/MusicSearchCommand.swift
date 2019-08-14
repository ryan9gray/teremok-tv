//
//  MusicSearchCommand.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 30/03/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

class MusicSearchCommand: BasicCommand {
    var phrase: String
    var itemsOnPage: Int
    var shiftItem: Int

    init(phrase: String,itemsOnPage: Int, shiftItem: Int) {
        self.phrase = phrase
        self.itemsOnPage = itemsOnPage
        self.shiftItem = shiftItem
    }
    func execute(success: ((MusicSearchtResponse) -> Void)?, failure: ApiCompletionBlock?) {
        requestObject(success: success, failure: failure)
    }

    override var method: String {
        return APIMethod.Music.search.methodName
    }

    override var parameters: [String : Any] {
        return ["phrase": phrase, "itemsOnPage": itemsOnPage, "shiftItem": shiftItem]
    }
}

class MusicSearchVarsCommand: BasicCommand {
    var phrase: String

    init(phrase: String) {
        self.phrase = phrase
    }

    func execute(success: ((SearchVarsResponse) -> Void)?, failure: ApiCompletionBlock?) {
        requestObject(success: success, failure: failure)
    }

    override var method: String {
        return APIMethod.Music.searchVars.methodName
    }

    override var parameters: [String : Any] {
        return [ "phrase": phrase ]
    }
}
