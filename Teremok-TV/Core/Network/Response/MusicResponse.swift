//
//  MusicResponse.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 27/03/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//
import ObjectMapper

final class MusicContentResponse: Mappable {
    var countItems: Int?
    var startItemIdInNextPage: Int?
    var items: [MusicAlbumResponse] = []
    var premium: Bool = false
    var premiumMusic: Bool = false

    // Mappable
    required init?(map: Map) {}

    func mapping(map: Map) {
        countItems        <- map["countItems"]
        startItemIdInNextPage     <- map["startItemIdInNextPage"]
        items     <- map["items"]
        premium     <- map["premium"]
        premiumMusic     <- map["premiumMusic"]
    }
}

final class MusicAlbumResponse: Mappable {
    var id: Int?
    var name: String?
    var description: String?
    var poster: String?

    // Mappable
    required init?(map: Map) {}

    func mapping(map: Map) {
        id        <- map["id"]
        name     <- map["name"]
        description     <- map["description"]
        poster     <- map["poster"]
    }
}

