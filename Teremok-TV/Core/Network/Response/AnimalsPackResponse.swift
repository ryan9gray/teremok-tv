//
//  AnimalsPackResponse.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 01/06/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

import ObjectMapper

final class AnimalsPackResponse: Mappable {
    var id: Int?
    var name: String?
    var free: Bool = false
    var png: String?
    var mp3: String?

    // Mappable
    required init?(map: Map) {}

    func mapping(map: Map) {
        id        <- map["id"]
        name     <- map["name"]
        free     <- map["free"]
        png     <- map["png"]
        mp3     <- map["mp3"]
    }
}
