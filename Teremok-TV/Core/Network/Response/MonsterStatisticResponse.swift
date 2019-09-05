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
    var currentweek: WeekTime!
    var pastweek: WeekTime!
    init?(map: Map) {}
    
    func mapping(map: Map) {
        daysToUpdate <- map["daysToUpdate"]
        currentweek <- map["currentweek"]
        pastweek <- map["pastweek"]
    }
    
    final class WeekTime: Mappable {
        var time: Int = 0
        init?(map: Map) {}
        
        func mapping(map: Map) {
            time <- map["avgtime"]
        }
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
