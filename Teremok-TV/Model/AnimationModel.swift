//
//  AnimationModel.swift
//  Teremok-TV
//
//  Created by R9G on 30/09/2018.
//  Copyright © 2018 xmedia. All rights reserved.
//

import ObjectMapper

class AnimationModel: Mappable {
    
    var link: String?
    var date: Date?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        link <- map["link"]
        date <- (map["date"], CustomDateFormatTransform(formatString: "yyyy-MM-dd hh:mm:ss"))

    }
}
