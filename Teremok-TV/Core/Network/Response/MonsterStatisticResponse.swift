//
//  MonsterStatisticResponse.swift
//  Teremok-TV
//
//  Created by Дмитрий Грищенко on 04/09/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

import ObjectMapper

final class MonsterStatisticResponse: Mappable {
    
    init?(map: Map) {}
    
    func mapping(map: Map) {
        
    }
}

final class MonsterStatisticRequest: Mappable {
    
    var difficulty: Int = 0
    var seconds: Int = 0
    
    init(difficulty: Int, seconds: Int) {
        self.difficulty = difficulty
        self.seconds = seconds
    }
    
    init?(map: Map) {}
    
    func mapping(map: Map) {
        difficulty <- map["difficulty"]
        seconds <- map["seconds"]
    }
}
