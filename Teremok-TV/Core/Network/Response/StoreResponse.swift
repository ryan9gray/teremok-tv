//
//  StoreResponse.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 24/02/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

import ObjectMapper

final class PromoCodeResponse: Mappable {
    var promoCodeTTL: Int?
    var promoCode: String?

    required init?(map: Map) {}

    func mapping(map: Map) {
        promoCodeTTL       <- map["promoCodeTTL"]
        promoCode       <- map["promoCode"]
    }
}

final class ActivateCodeResponse: Mappable {
    var state: String?
    var message: String?

    required init?(map: Map) {}

    func mapping(map: Map) {
        state       <- map["state"]
        message       <- map["message"]
    }
}
