//
//  RazdelResponse.swift
//  Teremok-TV
//
//  Created by R9G on 05/09/2018.
//  Copyright © 2018 xmedia. All rights reserved.
//

import ObjectMapper


final class RazdelResponse: Mappable {
    
    var id: Int?
    var name: String?
    var countItems: Int?
    var startItemIdInNextPage: Int?
    var userID: Int?
    var premium: Bool = false
    var items:[RazdelItemResponse]?

    
    // Mappable
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id       <- map["id"]
        name     <- map["name"]
        countItems     <- map["countItems"]
        startItemIdInNextPage     <- map["startItemIdInNextPage"]
        premium     <- map["premium"]
        items     <- map["items"]
        userID     <- map["userID"]
    }
}

final class RazdelItemResponse: Mappable {
    var id: Int?
    var name: String?
    var description: String?
    var poster: String?
    var copyrighter: CopyrighterResponse?
    var countItems: Int?
    
    // Mappable
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id       <- map["id"]
        name     <- map["name"]
        description     <- map["description"]
        poster     <- map["poster"]
        copyrighter     <- map["copyrighter"]
        countItems      <- map["countItems"]
    }
}
final class CopyrighterResponse: Mappable {
    
    var id: Int?
    var name: String?

    // Mappable
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id       <- map["id"]
        name     <- map["name"]
    }
}
