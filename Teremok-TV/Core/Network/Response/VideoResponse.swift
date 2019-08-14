//
//  VideoResponse.swift
//  Teremok-TV
//
//  Created by R9G on 05/09/2018.
//  Copyright © 2018 xmedia. All rights reserved.
//

import ObjectMapper


final class VideoResponse: Mappable {

    var id: Int?
    var name: String?
    var description: String?
    var countItems: Int?
    var startItemIdInNextPage: Int?
    var nextEpisodereleaseDate: String?
    var premium: Bool = false
    var items: [VideoModel]?
    var nextItem: Int?
    
    // Mappable
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id       <- map["razdId"]
        name     <- map["name"]
        description   <- map["description"]
        countItems   <- map["countItems"]
        startItemIdInNextPage   <- map["startItemIdInNextPage"]
        nextEpisodereleaseDate   <- map["nextEpisodereleaseDate"]
        premium   <- map["premium"]
        items   <- map["items"]
        nextItem   <- map["nextItem"]
    }
}


