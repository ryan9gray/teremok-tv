//
//  SubscriptionCommand.swift
//  Teremok-TV
//
//  Created by R9G on 10/11/2018.
//  Copyright © 2018 xmedia. All rights reserved.
//

import ObjectMapper

class SubscriptionCommand: BasicCommand {
    
    let receiptData: String
    let productId: String
    let transactionIdentifier: String
    let isRestore: Bool

    init(receiptData: String, productId: String, transactionIdentifier: String, isRestore: Bool) {
        self.receiptData = receiptData
        self.productId = productId
        self.transactionIdentifier = transactionIdentifier
        self.isRestore = isRestore
    }

    func execute(success: ((StateResponse) -> Void)?, failure: ApiCompletionBlock?) {
        requestObject(success: success, failure: failure)
    }
    
    override var method: String {
        return APIMethod.Purchase.iosSubscription.methodName
    }
    
    override var parameters: [String : Any] {
        return ["receipt-data": receiptData, "product_id": productId, "transactionIdentifier": transactionIdentifier, "isRestore": isRestore]
    }
}

