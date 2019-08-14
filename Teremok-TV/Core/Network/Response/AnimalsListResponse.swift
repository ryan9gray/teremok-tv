//
//  AnimalsGameResponse.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 01/06/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

import ObjectMapper

final class AnimalListResponse: Mappable {
    var id: Int?
    var name: String?
    var count: Int?
    var icon: String?

    // Mappable
    required init?(map: Map) {}

    func mapping(map: Map) {
        id        <- map["id"]
        name     <- map["name"]
        count     <- map["count"]
        icon     <- map["icon"]
    }
}

final class AnimalsListResponse: Mappable {
    var countItems: Int?
    var startItemIdInNextPage: Int?
    var list: [AnimalListResponse] = []

    // Mappable
    required init?(map: Map) {}

    func mapping(map: Map) {
        countItems        <- map["countItems"]
        startItemIdInNextPage     <- map["startItemIdInNextPage"]
        list     <- map["list"]
    }
}
