//
//  PromoCodeCommand.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 24/02/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

import ObjectMapper

class ActivatePromoCodeCommand: BasicCommand {

    let promoCode: String

    init(promoCode: String) {
        self.promoCode = promoCode
    }

    func execute(success: ((ActivateCodeResponse) -> Void)?, failure: ApiCompletionBlock?) {
        requestObject(success: success, failure: failure)
    }

    override var method: String {
        return APIMethod.Purchase.activatePromoCode.methodName
    }
	override var version: String {
		return "1.0"
	}

    override var parameters: [String : Any] {
        return ["promoCode": promoCode]
    }
}

class GetPromoCodeCommand: BasicCommand {

    func execute(success: ((PromoCodeResponse) -> Void)?, failure: ApiCompletionBlock?) {
        requestObject(success: success, failure: failure)
    }

    override var method: String {
        return APIMethod.Purchase.getPromoCode.methodName
    }

    override var parameters: [String : Any] {
        return [:]
    }
}
