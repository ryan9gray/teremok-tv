//
//  SearchCommand.swift
//  Teremok-TV
//
//  Created by R9G on 12/10/2018.
//  Copyright © 2018 xmedia. All rights reserved.
//

class SearchCommand: BasicCommand {
    
    let itemsOnPage: Int
    let shiftItem: Int
    
    init(itemsOnPage: Int, shiftItem: Int) {
        self.itemsOnPage = itemsOnPage
        self.shiftItem = shiftItem
    }
    func execute(success: ((SearchResponse) -> Void)?, failure: ApiCompletionBlock?) {
        requestObject(success: success, failure: failure)
    }
    
    override var method: String {
        return APIMethod.Content.search.methodName
    }
    
    override var parameters: [String : Any] {
        return ["itemsOnPage": itemsOnPage, "shiftItem": shiftItem]
    }
}

class SearchByKeywordsCommand: BasicCommand {
    let phrase: String
    let itemsOnPage: Int
    let shiftItem: Int

    init(phrase: String,itemsOnPage: Int, shiftItem: Int) {
        self.phrase = phrase
        self.itemsOnPage = itemsOnPage
        self.shiftItem = shiftItem
    }
    func execute(success: ((VideoResponse) -> Void)?, failure: ApiCompletionBlock?) {
        requestObject(success: success, failure: failure)
    }

    override var method: String {
        return APIMethod.Content.searchByKeywords.methodName
    }

    override var parameters: [String : Any] {
        return ["phrase": phrase, "itemsOnPage": itemsOnPage, "shiftItem": shiftItem]
    }
}
