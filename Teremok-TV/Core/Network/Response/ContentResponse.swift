//
//  ContentResponse.swift
//  Teremok-TV
//
//  Created by R9G on 12/09/2018.
//  Copyright © 2018 xmedia. All rights reserved.
//

import ObjectMapper

final class ViewsResponse: Mappable {
    
    var count: Int?

    required init?(map: Map) {}
    
    func mapping(map: Map) {
        count       <- map["count"]
    }
}
final class AchievementsResponse: Mappable {
    
    var name: String?
    var state: Bool?
    var imageLink: String?
    
    var description: String?

    var progress: Int?
    var target: Int?

    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        name       <- map["name"]
        state     <- map["state"]
        imageLink     <- map["imageLink"]
        description     <- map["description"]
        progress     <- map["progress"]
        target     <- map["target"]
    }
}
final class LikeResponse: Mappable {
    
    var id: String?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id       <- map["id"]
    }
}

final class ActionResponse: Mappable {
    
    var action: Action?
    
    enum Action: String {
        case removed
        case added
        case no = ""
    }
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        action       <- map["action"]
    }
}

final class StatusResponse: Mappable {
    var status: String = ""

    required init?(map: Map) {}

    func mapping(map: Map) {
        status       <- map["status"]
    }
}
