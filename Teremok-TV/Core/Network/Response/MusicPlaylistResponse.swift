//
//  MusicLpaylistResponse.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 30/03/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

import ObjectMapper

final class MusicPlaylistResponse: Mappable {
    var countItems: Int?
    var name: String?
    var id: Int?
    var items: [MusicPlaylistItemResponse]?
    var premium: Bool = false
    var premiumMusic: Bool = false
    var poster: String?

    // Mappable
    required init?(map: Map) {}

    func mapping(map: Map) {
        countItems        <- map["countItems"]
        name     <- map["name"]
        id     <- map["id"]
        items     <- map["items"]
        premium     <- map["premium"]
        premiumMusic     <- map["premiumMusic"]
        poster     <- map["poster"]
    }
}

final class MusicPlaylistItemResponse: Mappable {
    var id: Int?
    var name: String = ""
    var description: String = ""
    var copyrighter: CopyrighterResponse?
    var listenMe: Bool = false
    var downloadMe: Bool = false
    var inFavorites: Bool = false

    var link: String?
    var duration: Int = 0
    var album: AlbumResponse?

    // Mappable
    required init?(map: Map) {}

    func mapping(map: Map) {
        id        <- map["id"]
        name     <- map["name"]
        description     <- map["description"]
        copyrighter     <- map["copyrighter"]
        listenMe     <- map["listenMe"]
        downloadMe     <- map["downloadMe"]
        inFavorites     <- map["inFavorites"]
        link     <- map["link"]
        duration     <- map["duration"]
        album     <- map["album"]
    }
}
final class AlbumResponse: Mappable {

    var id: Int = 0
    var name: String = ""
    var poster: String = ""

    // Mappable
    required init?(map: Map) {}

    func mapping(map: Map) {
        id       <- map["id"]
        name     <- map["name"]
        poster     <- map["poster"]

    }
}
final class MusicSearchtResponse: Mappable {
    var countItems: Int = 0
    var items: [MusicPlaylistItemResponse] = []
    var premium: Bool = false
    var premiumMusic: Bool = false
    var startItemIdInNextPage: Int?

    // Mappable
    required init?(map: Map) {}

    func mapping(map: Map) {
        countItems        <- map["countItems"]
        items     <- map["items"]
        premium     <- map["premium"]
        premiumMusic     <- map["premiumMusic"]
        startItemIdInNextPage     <- map["startItemIdInNextPage"]

    }
}
