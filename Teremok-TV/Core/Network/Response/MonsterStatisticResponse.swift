//
//  MonsterStatisticResponse.swift
//  Teremok-TV
//
//  Created by Дмитрий Грищенко on 04/09/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

import ObjectMapper

final class MonsterStatisticResponse: Mappable {
    var daysToUpdate: Int = 0
    var currentweek: Int = 0
    var pastweek: Int = 0
    init?(map: Map) {}
    
    func mapping(map: Map) {
        daysToUpdate <- map["daysToUpdate"]
        currentweek <- map["currentweek"]["avgtime"]
        pastweek <- map["pastweek"]["avgtime"]
    }
}

final class MonsterStatisticRequest: Mappable {
    var round: Int = 0
    var seconds: Int = 0
    
    init(round: Int, seconds: Int) {
        self.round = round
        self.seconds = seconds
    }
    
    init?(map: Map) {}
    
    func mapping(map: Map) {
        round <- map["round"]
        seconds <- map["seconds"]
    }
}
