//
//  SearchResponse.swift
//  Teremok-TV
//
//  Created by R9G on 12/10/2018.
//  Copyright © 2018 xmedia. All rights reserved.
//

import ObjectMapper


final class SearchResponse: Mappable {
    var startItemIdInNextPage: Int?
    var premium: Bool = false
    
    var items:[SearchItemResponse]?
    
    // Mappable
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        startItemIdInNextPage     <- map["startItemIdInNextPage"]
        premium     <- map["premium"]
        items     <- map["items"]
    }
}

final class SearchItemResponse: Mappable {
    var seriesId: Int?
    var pictureUrl: String?
    
    // Mappable
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        seriesId     <- map["seriesId"]
        pictureUrl     <- map["pictureUrl"]
    }
}

final class SearchVarsResponse: Mappable {
    var phrases: [String]?

    // Mappable
    required init?(map: Map) {}

    func mapping(map: Map) {
        phrases     <- map["phrases"]
    }
}
