//
//  MainContentResponse.swift
//  Teremok-TV
//
//  Created by R9G on 25/08/2018.
//  Copyright © 2018 xmedia. All rights reserved.
//


import ObjectMapper


final class MainContentResponse: Mappable {
    
    var razds: [RazdelModel]?

    var premium: Bool = false
    
    // Mappable
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        razds        <- map["razds"]
        premium     <- map["premium"]
    }
}


final class RazdelModel: Mappable {
    var razdId: Int?
    var name: String?
    var description: String?
    var animationLastUpdate: Date?
    var animationUrl: String?
    var countItems: Int?
    var top: [RazdelModelTop]?
    
    var itemType: ItemType?
    
    enum ItemType: String {
        case series
        case videos
    }

    // Mappable
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        razdId        <- map["razdId"]
        name     <- map["name"]
        description   <- map["description"]
        animationUrl   <- map["animationUrl"]
        animationLastUpdate   <- (map["animationLastUpdate"], CustomDateFormatTransform(formatString: "yyyy-MM-dd hh:mm:ss"))
        itemType        <- map["itemType"]
        countItems      <- map["countItems"]
        top             <- map["top"]
    }
    
    final class RazdelModelTop: Mappable {
        var id: Int?
        var poster: String?
        var name: String?
        
        required init?(map: Map) {}
        
        func mapping(map: Map) {
            id      <- map["id"]
            poster  <- map["poster"]
            name    <- map["name"]
        }
    }
}
