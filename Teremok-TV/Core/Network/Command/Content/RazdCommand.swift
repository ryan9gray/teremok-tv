//
//  RazdCommand.swift
//  Teremok-TV
//
//  Created by R9G on 05/09/2018.
//  Copyright © 2018 xmedia. All rights reserved.
//

import Alamofire

class RazdCommand: BasicCommand {
    let razdId: Int
    let itemsOnPage: Int
    let shiftItem: Int
    
    init(razdId: Int, itemsOnPage: Int, shiftItem: Int) {
        self.razdId = razdId
        self.itemsOnPage = itemsOnPage
        self.shiftItem = shiftItem
    }
    
    func execute(success: ((RazdelResponse) -> Void)?, failure: ApiCompletionBlock?) {
        requestObject(success: success, failure: failure)
    }

    override var method: String {
        return APIMethod.Content.razd.methodName
    }
    
    override var parameters: [String : Any] {
        return ["razdId": razdId, "itemsOnPage": itemsOnPage, "shiftItem": shiftItem]
    }
}
class CatalogCommand: BasicCommand {
    let itemsOnPage: Int
    let shiftItem: Int
    
    init(itemsOnPage: Int, shiftItem: Int) {
        self.itemsOnPage = itemsOnPage
        self.shiftItem = shiftItem
    }
    
    func execute(success: ((RazdelResponse) -> Void)?, failure: ApiCompletionBlock?) {
        requestObject(success: success, failure: failure)
    }
    
    override var method: String {
        return APIMethod.Content.catalog.methodName
    }
    
    override var parameters: [String : Any] {
        return ["itemsOnPage": itemsOnPage, "shiftItem": shiftItem]
    }
}
